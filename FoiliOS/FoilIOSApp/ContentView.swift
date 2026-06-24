import AVFoundation
import SwiftUI

struct ContentView: View {
    private let bridge = FoilKeyboardBridge()
    private let actionColumns = [
        GridItem(.flexible(minimum: 118), spacing: 10),
        GridItem(.flexible(minimum: 118), spacing: 10)
    ]

    @StateObject private var audioCapture = AudioCaptureController()
    @StateObject private var transcription = TranscriptionController()
    @State private var snapshot = FoilKeyboardSnapshot.initial
    @State private var storageReport = FoilKeyboardStorageReport.initial
    @State private var keyboardHealth = FoilKeyboardHealthReport.initial
    @State private var secureEntry = ""
    @State private var providerKeyEntry = ""
    @State private var providerCredentialMessage = ""
    @State private var showDiagnostics = false
    @State private var lastHandledCommandID: String?
    @AppStorage("foil.onboarding.selectedRoute.v1") private var selectedRouteID = FoilDictationLoopPresenter.defaultBetaRouteID
    private let refreshTimer = Timer.publish(every: 0.75, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Foil iOS")
                            .font(.title.weight(.semibold))
                    }

                    primaryFlowSections

                    if let handoffGuidance {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Handoff")
                                .font(.headline)
                            FoilStatusRow(handoffGuidance, systemImage: "arrow.left.arrow.right")
                                .font(.callout)
                        }
                    }

                    if let recoveryMessage {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recovery")
                                .font(.headline)
                            FoilStatusRow(recoveryMessage, systemImage: "exclamationmark.arrow.triangle.2.circlepath")
                                .font(.callout)
                            if transcription.providerRecoveryRequiresKeyUpdate {
                                FoilSetupRow(
                                    title: "Update provider key",
                                    detail: "A saved key is not provider-verified until transcription succeeds.",
                                    systemImage: "key.fill"
                                )
                                providerCredentialEditor
                            }
                            keyboardRecoveryChecklist
                            testedTargetsPanel

                            LazyVGrid(columns: actionColumns, alignment: .leading, spacing: 10) {
                                if canRetryTranscription {
                                    Button {
                                        Task { await transcription.transcribeLatestRecording(audioCapture.lastRecordingURL) }
                                    } label: {
                                        Label("Retry transcription", systemImage: "arrow.clockwise")
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .accessibilityIdentifier("retry-transcription-button")
                                }

                                Button {
                                    bridge.reset()
                                    refresh()
                                } label: {
                                    Label("Reset shared state", systemImage: "arrow.counterclockwise")
                                }
                                .buttonStyle(.bordered)
                                .accessibilityIdentifier("recovery-reset-shared-state-button")
                            }
                            .controlSize(.large)
                            .labelStyle(.titleAndIcon)
                            .buttonBorderShape(.roundedRectangle(radius: 8))
                        }
                    }

                    FoilAdvancedSupportDisclosure(
                        isExpanded: $showDiagnostics,
                        secureEntry: $secureEntry,
                        storageReportSummary: storageReportSummary,
                        transcriptReviewVisible: transcriptReviewPresentation != nil,
                        lastRecordingName: audioCapture.lastRecordingURL?.lastPathComponent,
                        markListening: {
                            bridge.markListening()
                            refresh()
                        },
                        completeFakeTranscript: {
                            bridge.completeFakeTranscript()
                            refresh()
                        },
                        resetSharedState: {
                            bridge.reset()
                            refresh()
                        }
                    )

                    Spacer(minLength: 0)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .navigationTitle("Foil")
            .onAppear(perform: refresh)
            .onReceive(refreshTimer) { _ in refresh() }
            .onOpenURL { url in
                guard url.scheme == FoilIOSConstants.appURLScheme else { return }
                switch url.host {
                case "keyboard-health":
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                    let fullAccessValue = components?.queryItems?.first { $0.name == "fullAccess" }?.value
                    bridge.recordKeyboardHealth(fullAccessEnabled: fullAccessValue == "on", snapshot: bridge.load())
                case "complete":
                    bridge.completeFakeTranscript()
                case "reset":
                    bridge.reset()
                case "start":
                    bridge.markListening()
                    Task { await audioCapture.startRecording() }
                case "stop":
                    audioCapture.stopRecording()
                case "transcribe":
                    Task { await transcription.transcribeLatestRecording(audioCapture.lastRecordingURL) }
                default:
                    bridge.markListening()
                }
                refresh()
            }
        }
        .onAppear(perform: handlePendingCommand)
        .onReceive(refreshTimer) { _ in handlePendingCommand() }
    }

    @ViewBuilder
    private var primaryFlowSections: some View {
        if shouldPrioritizeSetup {
            routeFirstOnboardingPanel
            dictationConsole
            if let transcriptReviewPresentation {
                transcriptReviewPanel(transcriptReviewPresentation)
            }
        } else {
            dictationConsole
            if let transcriptReviewPresentation {
                transcriptReviewPanel(transcriptReviewPresentation)
            }
            routeFirstOnboardingPanel
        }
    }

    private var dictationConsole: some View {
        FoilDictationConsoleView(
            stage: dictationStage,
            snapshotMessage: snapshot.message,
            audioStatus: audioCapture.status,
            transcriptionStatus: transcription.status,
            isRecording: audioCapture.isRecording,
            hasSavedRecording: audioCapture.lastRecordingURL != nil,
            performPrimary: perform,
            performSecondary: perform,
            startRecording: {
                Task { await audioCapture.startRecording() }
            },
            stopRecording: {
                audioCapture.stopRecording()
                refresh()
            },
            cancelRecording: {
                audioCapture.cancelRecording()
                refresh()
            },
            transcribeLatest: {
                Task { await transcription.transcribeLatestRecording(audioCapture.lastRecordingURL) }
            }
        )
    }

    private func transcriptReviewPanel(_ presentation: FoilTranscriptReviewPresentation) -> some View {
        FoilTranscriptReviewPanel(
            presentation: presentation,
            canRetry: presentation.canRetryRecording && !audioCapture.isRecording,
            retry: retryRecordingFromTranscriptReview,
            reset: {
                bridge.reset()
                refresh()
            }
        )
    }

    private var providerCredentialEditor: some View {
        FoilProviderCredentialEditor(
            providerKeyEntry: $providerKeyEntry,
            message: providerCredentialMessage,
            hasConfiguredAPIKey: transcription.hasConfiguredAPIKey,
            save: saveProviderKey,
            clear: clearProviderKey
        )
    }

    private var routeFirstOnboardingPanel: some View {
        FoilRouteFirstOnboardingPanel(
            selectedRouteID: $selectedRouteID,
            setupReadiness: setupReadiness,
            onboardingReadiness: onboardingReadiness,
            microphonePermissionSummary: microphonePermissionSummary,
            providerCredentialSummary: transcription.credentialSummary,
            hasConfiguredAPIKey: transcription.hasConfiguredAPIKey,
            keyboardFullAccessEnabled: keyboardHealth.fullAccessState == .enabled,
            keyboardHealthSummary: keyboardHealthSummary,
            storageHealthSummary: storageHealthSummary,
            resetSharedState: {
                bridge.reset()
                refresh()
            },
            providerCredentialEditor: {
                providerCredentialEditor
            }
        )
    }

    private var testedTargetsPanel: some View {
        FoilTestedTargetsPanel()
    }

    @ViewBuilder
    private var keyboardRecoveryChecklist: some View {
        FoilKeyboardRecoveryChecklist(steps: keyboardHealthPresentation.recoverySteps)
    }

    private func refresh() {
        snapshot = bridge.load()
        storageReport = bridge.storageReport()
        keyboardHealth = bridge.keyboardHealthReport()
    }

    private func handlePendingCommand() {
        guard let command = bridge.loadCommand(),
              command.id != lastHandledCommandID else {
            return
        }

        lastHandledCommandID = command.id
        bridge.clearCommand()

        switch command.action {
        case .startRecording:
            bridge.markListening()
            Task { await audioCapture.startRecording() }
        case .stopRecording:
            audioCapture.stopRecording()
            refresh()
        case .transcribeLatest:
            Task { await transcription.transcribeLatestRecording(audioCapture.lastRecordingURL) }
        case .resetSharedState:
            bridge.reset()
            refresh()
        case .completeFakeTranscript:
            bridge.completeFakeTranscript()
            refresh()
        }
    }

    private func retryRecordingFromTranscriptReview() {
        bridge.reset()
        refresh()
        Task { await audioCapture.startRecording() }
    }

    private func saveProviderKey() {
        do {
            try transcription.saveGroqAPIKey(providerKeyEntry)
            providerKeyEntry = ""
            providerCredentialMessage = "Groq key saved. Provider will verify on the next transcription."
        } catch {
            providerCredentialMessage = error.localizedDescription
        }
    }

    private func clearProviderKey() {
        do {
            try transcription.clearGroqAPIKey()
            providerKeyEntry = ""
            providerCredentialMessage = "Groq key cleared"
        } catch {
            providerCredentialMessage = error.localizedDescription
        }
    }

    private var storageReportSummary: String {
        let file = storageReport.canonicalWriteSucceeded ? "file ok" : "file failed"
        let verifiedPhase = storageReport.canonicalVerificationPhase?.displayName ?? "unverified"
        let verifiedTranscript = storageReport.canonicalVerificationHasTranscript == true ? "has transcript" : "no transcript"
        let defaults = storageReport.defaultsWriteAttempted ? "defaults written" : "defaults not written"
        return "Storage \(storageReport.operation): \(file), \(defaults), verified \(verifiedPhase) \(verifiedTranscript)"
    }

    private var recoveryMessage: String? {
        if keyboardHealth.fullAccessState == .disabled,
           let keyboardRecovery = keyboardHealthPresentation.recoveryMessage {
            return keyboardRecovery
        }
        if snapshot.transcript?.isEmpty == false {
            return "Transcript waiting. Insert it once from Foil Keyboard, or reset shared state."
        }
        if let message = audioCapture.recoveryMessage {
            return message
        }
        if let message = transcription.recoveryMessage {
            return message
        }
        if snapshot.phase == .failed {
            return snapshot.message
        }
        if let storageRecovery = storageHealthPresentation.recoveryMessage {
            return storageRecovery
        }
        if let keyboardRecovery = keyboardHealthPresentation.recoveryMessage {
            return keyboardRecovery
        }
        return nil
    }

    private var handoffGuidance: String? {
        switch snapshot.phase {
        case .handoffRequested:
            return "Foil is open for dictation."
        case .listening:
            return "Recording is active."
        case .processing:
            return "Transcript creation is underway."
        case .complete:
            return "Transcript is ready for the keyboard."
        case .failed:
            return "Recovery needed before keyboard insertion."
        case .idle:
            return nil
        }
    }

    private var canRetryTranscription: Bool {
        transcription.recoveryMessage != nil &&
            !transcription.providerRecoveryRequiresKeyUpdate &&
            audioCapture.lastRecordingURL != nil &&
            !audioCapture.isRecording
    }

    private var microphonePermissionSummary: String {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            "Microphone allowed"
        case .denied:
            "Microphone blocked in Settings"
        case .undetermined:
            "Microphone will be requested"
        @unknown default:
            "Microphone status unavailable"
        }
    }

    private var microphoneAllowed: Bool {
        AVAudioApplication.shared.recordPermission == .granted
    }

    private var microphoneSetupState: FoilMicrophoneSetupState {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            .allowed
        case .denied:
            .blocked
        case .undetermined:
            .needsPrompt
        @unknown default:
            .unavailable
        }
    }

    private var keyboardHealthSummary: String {
        keyboardHealthPresentation.detail
    }

    private var keyboardHealthPresentation: FoilKeyboardHealthPresentation {
        FoilDictationLoopPresenter.keyboardHealthPresentation(report: keyboardHealth)
    }

    private var storageHealthPresentation: FoilStorageHealthPresentation {
        FoilDictationLoopPresenter.storageHealthPresentation(
            snapshot: snapshot,
            storageReport: storageReport
        )
    }

    private var setupReadiness: FoilSetupReadinessPresentation {
        FoilDictationLoopPresenter.setupReadinessPresentation(
            hasProviderKey: transcription.hasConfiguredAPIKey,
            microphoneState: microphoneSetupState,
            keyboardHealth: keyboardHealth,
            snapshot: snapshot
        )
    }

    private var storageHealthSummary: String {
        storageHealthPresentation.detail
    }

    private var onboardingReadiness: FoilOnboardingReadinessPresentation {
        FoilDictationLoopPresenter.onboardingReadinessPresentation(
            selectedRouteID: selectedRouteID,
            hasConfiguredAPIKey: transcription.hasConfiguredAPIKey,
            microphoneAllowed: microphoneAllowed,
            keyboardHealth: keyboardHealth,
            storageReport: storageReport,
            snapshot: snapshot
        )
    }

    private var dictationStage: FoilAppLoopPresentation {
        FoilDictationLoopPresenter.appPresentation(
            snapshot: snapshot,
            isRecording: audioCapture.isRecording,
            hasSavedRecording: audioCapture.lastRecordingURL != nil,
            isTranscribing: transcription.status == "Transcribing",
            recoveryMessage: recoveryMessage,
            providerRecoveryRequiresKeyUpdate: transcription.providerRecoveryRequiresKeyUpdate
        )
    }

    private var shouldPrioritizeSetup: Bool {
        FoilDictationLoopPresenter.shouldPrioritizeSetup(
            onboardingReadiness: onboardingReadiness,
            snapshot: snapshot,
            isRecording: audioCapture.isRecording,
            hasSavedRecording: audioCapture.lastRecordingURL != nil,
            isTranscribing: transcription.status == "Transcribing"
        )
    }

    private var transcriptReviewPresentation: FoilTranscriptReviewPresentation? {
        FoilDictationLoopPresenter.transcriptReviewPresentation(
            snapshot: snapshot,
            hasSavedRecording: audioCapture.lastRecordingURL != nil
        )
    }

    private func perform(_ action: FoilAppPrimaryAction) {
        switch action {
        case .record:
            Task { await audioCapture.startRecording() }
        case .stopRecording:
            audioCapture.stopRecording()
            refresh()
        case .createTranscript, .retryTranscript:
            Task { await transcription.transcribeLatestRecording(audioCapture.lastRecordingURL) }
        case .reset:
            bridge.reset()
            refresh()
        }
    }

    private func perform(_ action: FoilAppSecondaryAction) {
        switch action {
        case .cancelRecording:
            audioCapture.cancelRecording()
            refresh()
        }
    }

}

#Preview {
    ContentView()
}
