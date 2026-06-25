import AVFoundation
import SwiftUI

struct ContentView: View {
    private let bridge = FoilKeyboardBridge()

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
                        FoilRecoverySection(
                            message: recoveryMessage,
                            showsProviderKeyRecovery: transcription.providerRecoveryRequiresKeyUpdate,
                            keyboardRecoverySteps: keyboardHealthPresentation.recoverySteps,
                            canRetryTranscription: canRetryTranscription,
                            retryTranscription: {
                                Task { await transcription.transcribeLatestRecording(audioCapture.lastRecordingURL) }
                            },
                            resetSharedState: {
                                bridge.reset()
                                refresh()
                            },
                            providerCredentialEditor: {
                                providerCredentialEditor
                            }
                        )
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
            .onOpenURL(perform: handleOpenURL)
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
            performPrimary: performPrimary,
            performSecondary: performSecondary,
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

    private func refresh() {
        snapshot = bridge.load()
        storageReport = bridge.storageReport()
        keyboardHealth = bridge.keyboardHealthReport()
    }

    private func handlePendingCommand() {
        FoilContentCommandRouter.handlePendingCommand(
            bridge: bridge,
            lastHandledCommandID: &lastHandledCommandID,
            audioCapture: audioCapture,
            transcription: transcription,
            refresh: refresh
        )
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
        FoilContentPresentationSupport.storageReportSummary(storageReport)
    }

    private var recoveryMessage: String? {
        FoilContentPresentationSupport.recoveryMessage(
            keyboardFullAccessState: keyboardHealth.fullAccessState,
            keyboardHealthPresentation: keyboardHealthPresentation,
            snapshot: snapshot,
            audioRecoveryMessage: audioCapture.recoveryMessage,
            transcriptionRecoveryMessage: transcription.recoveryMessage,
            storageHealthPresentation: storageHealthPresentation
        )
    }

    private var handoffGuidance: String? {
        FoilContentPresentationSupport.handoffGuidance(for: snapshot.phase)
    }

    private var canRetryTranscription: Bool {
        transcription.recoveryMessage != nil &&
            !transcription.providerRecoveryRequiresKeyUpdate &&
            audioCapture.lastRecordingURL != nil &&
            !audioCapture.isRecording
    }

    private var microphonePermissionSummary: String {
        FoilContentPresentationSupport.microphonePermissionSummary
    }

    private var microphoneAllowed: Bool {
        AVAudioApplication.shared.recordPermission == .granted
    }

    private var microphoneSetupState: FoilMicrophoneSetupState {
        FoilContentPresentationSupport.microphoneSetupState
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

    private func handleOpenURL(_ url: URL) {
        FoilContentCommandRouter.handleOpenURL(
            url,
            bridge: bridge,
            audioCapture: audioCapture,
            transcription: transcription,
            refresh: refresh
        )
    }

    private func performPrimary(_ action: FoilAppPrimaryAction) {
        FoilContentCommandRouter.perform(
            action,
            bridge: bridge,
            audioCapture: audioCapture,
            transcription: transcription,
            refresh: refresh
        )
    }

    private func performSecondary(_ action: FoilAppSecondaryAction) {
        FoilContentCommandRouter.perform(action, audioCapture: audioCapture, refresh: refresh)
    }
}
