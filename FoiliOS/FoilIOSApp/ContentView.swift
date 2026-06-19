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
    @AppStorage("foil.onboarding.selectedRoute.v1") private var selectedRouteID = FoilDictationLoopPresenter.macRouteID
    private let refreshTimer = Timer.publish(every: 0.75, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Foil iOS")
                            .font(.title.weight(.semibold))
                    }

                    dictationConsole

                    if let transcriptReviewPresentation {
                        transcriptReviewPanel(transcriptReviewPresentation)
                    }

                    routeFirstOnboardingPanel

                    if let handoffGuidance {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Handoff")
                                .font(.headline)
                            statusRow(handoffGuidance, systemImage: "arrow.left.arrow.right")
                                .font(.callout)
                        }
                    }

                    if let recoveryMessage {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recovery")
                                .font(.headline)
                            statusRow(recoveryMessage, systemImage: "exclamationmark.arrow.triangle.2.circlepath")
                                .font(.callout)
                            keyboardRecoveryChecklist

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

                    DisclosureGroup("Advanced / Support", isExpanded: $showDiagnostics) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(FoilDictationLoopPresenter.advancedSupportPresentation()) { item in
                                setupRow(title: item.title, detail: item.detail, systemImage: item.systemImage)
                            }

                            Divider()

                            Text("Safe test targets")
                                .font(.callout.weight(.semibold))

                            ForEach(FoilDictationLoopPresenter.betaGuidancePresentation()) { item in
                                setupRow(title: item.title, detail: item.detail, systemImage: item.systemImage)
                            }

                            Divider()

                            statusRow(storageReportSummary, systemImage: "externaldrive")
                                .accessibilityIdentifier("keyboard-storage-report-summary")
                            if transcriptReviewPresentation != nil {
                                statusRow("Transcript visible in review", systemImage: "text.quote")
                                    .accessibilityIdentifier("diagnostics-transcript-review-visible")
                            }
                            if let lastRecordingURL = audioCapture.lastRecordingURL {
                                statusRow(lastRecordingURL.lastPathComponent, systemImage: "waveform.path")
                                    .font(.caption.monospaced())
                            }

                            SecureField("Secure field rejection test", text: $secureEntry)
                                .textContentType(.password)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .accessibilityIdentifier("secure-rejection-field")
                                .textFieldStyle(.roundedBorder)

                            LazyVGrid(columns: actionColumns, alignment: .leading, spacing: 10) {
                                diagnosticButtons
                            }
                            .controlSize(.large)
                            .labelStyle(.titleAndIcon)
                            .buttonBorderShape(.roundedRectangle(radius: 8))
                        }
                        .padding(.top, 8)
                    }
                    .accessibilityIdentifier("advanced-support-disclosure")

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

    private var dictationConsole: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Label(dictationStage.title, systemImage: dictationStage.systemImage)
                    .font(.headline)
                Spacer(minLength: 8)
                Text(dictationStage.badge)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(dictationStage.tone.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(dictationStage.tone.color.opacity(0.12), in: Capsule())
            }

            Text(dictationStage.detail)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .accessibilityIdentifier("dictation-stage-detail")

            if let primaryAction = dictationStage.primaryAction {
                Button {
                    perform(primaryAction)
                } label: {
                    Label(primaryAction.title, systemImage: primaryAction.systemImage)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .buttonBorderShape(.roundedRectangle(radius: 8))
                .accessibilityIdentifier(primaryAction.accessibilityIdentifier)
            }

            VStack(alignment: .leading, spacing: 10) {
                statusRow(snapshot.message, systemImage: "keyboard")
                statusRow(audioCapture.status, systemImage: "mic")
                statusRow(transcription.status, systemImage: "text.bubble")
            }
            .font(.callout)
            .accessibilityIdentifier("dictation-status-stack")

            LazyVGrid(columns: actionColumns, alignment: .leading, spacing: 10) {
                recordingButtons
            }
            .controlSize(.regular)
            .labelStyle(.titleAndIcon)
            .buttonBorderShape(.roundedRectangle(radius: 8))
        }
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(dictationStage.tone.color.opacity(0.28))
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("dictation-console")
    }

    private func transcriptReviewPanel(_ presentation: FoilTranscriptReviewPresentation) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Review transcript", systemImage: "text.quote")
                .font(.headline)

            Text(presentation.guidance)
                .font(.callout)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("transcript-review-guidance")

            Text(presentation.transcript)
                .font(.body)
                .textSelection(.enabled)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(.secondary.opacity(0.24))
                )
                .accessibilityIdentifier("transcript-review-body")

            VStack(alignment: .leading, spacing: 10) {
                Button {
                    retryRecordingFromTranscriptReview()
                } label: {
                    Label(presentation.retryTitle, systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!presentation.canRetryRecording || audioCapture.isRecording)
                .accessibilityIdentifier("transcript-review-retry-recording-button")

                Button {
                    bridge.reset()
                    refresh()
                } label: {
                    Label(presentation.resetTitle, systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("transcript-review-reset-button")
            }
            .controlSize(.large)
            .labelStyle(.titleAndIcon)
            .buttonBorderShape(.roundedRectangle(radius: 8))
        }
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color.accentColor.opacity(0.28))
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("transcript-review-panel")
    }

    @ViewBuilder
    private var recordingButtons: some View {
        Button {
            Task { await audioCapture.startRecording() }
        } label: {
            Label("Record", systemImage: "record.circle")
        }
        .buttonStyle(.borderedProminent)
        .disabled(audioCapture.isRecording)
        .accessibilityIdentifier("start-recording-button")

        Button {
            audioCapture.stopRecording()
            refresh()
        } label: {
            Label("Stop", systemImage: "stop.circle")
        }
        .buttonStyle(.bordered)
        .disabled(!audioCapture.isRecording)
        .accessibilityIdentifier("stop-recording-button")

        Button {
            Task { await transcription.transcribeLatestRecording(audioCapture.lastRecordingURL) }
        } label: {
            Label("Transcribe", systemImage: "text.bubble")
        }
        .buttonStyle(.bordered)
        .disabled(audioCapture.lastRecordingURL == nil || audioCapture.isRecording)
        .accessibilityIdentifier("transcribe-latest-button")
    }

    private var providerCredentialEditor: some View {
        VStack(alignment: .leading, spacing: 8) {
            SecureField("Groq API key", text: $providerKeyEntry)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("provider-key-field")

            HStack(spacing: 10) {
                Button {
                    saveProviderKey()
                } label: {
                    Label("Save key", systemImage: "key")
                }
                .buttonStyle(.borderedProminent)
                .disabled(providerKeyEntry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .accessibilityIdentifier("save-provider-key-button")

                Button {
                    clearProviderKey()
                } label: {
                    Label("Clear key", systemImage: "trash")
                }
                .buttonStyle(.bordered)
                .disabled(!transcription.hasConfiguredAPIKey)
                .accessibilityIdentifier("clear-provider-key-button")
            }

            if !providerCredentialMessage.isEmpty {
                Text(providerCredentialMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("provider-credential-message")
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var routeFirstOnboardingPanel: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Choose your setup route")
                    .font(.headline)
                Text("Start with the Mac path when it is available, or finish setup today with an API key on this iPhone.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(FoilDictationLoopPresenter.routeChoicePresentation()) { route in
                    routeChoiceButton(route)
                }
            }

            Divider()

            selectedRouteDetails
        }
        .font(.callout)
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(.secondary.opacity(0.18))
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("route-first-onboarding")
    }

    private func routeChoiceButton(_ route: FoilSetupRoutePresentation) -> some View {
        Button {
            selectedRouteID = route.routeID
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: selectedRouteID == route.routeID ? "checkmark.circle.fill" : route.systemImage)
                    .foregroundStyle(selectedRouteID == route.routeID ? Color.accentColor : Color.secondary)
                    .frame(width: 22)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(route.title)
                            .font(.callout.weight(.semibold))
                        Text(route.badge)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(route.isUsableNow ? .green : .orange)
                    }
                    Text(route.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .padding(10)
        .background(.background.opacity(0.6), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(selectedRouteID == route.routeID ? Color.accentColor.opacity(0.5) : Color.secondary.opacity(0.18))
        )
        .accessibilityIdentifier("route-choice-\(route.routeID)")
    }

    @ViewBuilder
    private var selectedRouteDetails: some View {
        switch selectedRouteID {
        case FoilDictationLoopPresenter.macRouteID:
            macRouteDetails
        case FoilDictationLoopPresenter.advancedRouteID:
            advancedRouteDetails
        default:
            iPhoneAPIKeyRouteDetails
        }
    }

    private var macRouteDetails: some View {
        let preview = FoilDictationLoopPresenter.macPairingPreviewPresentation()

        return VStack(alignment: .leading, spacing: 12) {
            setupRow(
                title: preview.title,
                detail: preview.detail,
                systemImage: "desktopcomputer"
            )
            setupRow(
                title: "Bridge contract",
                detail: preview.contractDetail,
                systemImage: "point.3.connected.trianglepath.dotted"
            )
            setupRow(
                title: preview.receiptName,
                detail: preview.receiptDetail,
                systemImage: "doc.text.magnifyingglass"
            )
            readinessPanel
            Button {
                selectedRouteID = FoilDictationLoopPresenter.iPhoneAPIKeyRouteID
            } label: {
                Label(preview.fallbackTitle, systemImage: "iphone.gen3")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle(radius: 8))
            .accessibilityIdentifier("select-iphone-api-route-button")
        }
    }

    private var iPhoneAPIKeyRouteDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(FoilDictationLoopPresenter.iPhoneAPIKeySetupPresentation()) { item in
                    setupRow(title: item.title, detail: item.detail, systemImage: item.systemImage)
                }
            }

            Divider()

            Text("Current status")
                .font(.callout.weight(.semibold))

            setupReadinessPanel

            setupRow(
                title: "Microphone",
                detail: microphonePermissionSummary,
                systemImage: "mic"
            )
            setupRow(
                title: "Provider route",
                detail: transcription.credentialSummary,
                systemImage: transcription.hasConfiguredAPIKey ? "key.fill" : "key"
            )
            providerCredentialEditor
            setupRow(
                title: "Keyboard health",
                detail: keyboardHealthSummary,
                systemImage: keyboardHealth.fullAccessState == .enabled ? "checkmark.circle" : "exclamationmark.circle"
            )
            keyboardRecoveryChecklist
            setupRow(
                title: "Shared state",
                detail: storageHealthSummary,
                systemImage: "externaldrive"
            )

            readinessPanel

            Button {
                bridge.reset()
                refresh()
            } label: {
                Label("Reset shared state", systemImage: "arrow.counterclockwise")
            }
            .buttonStyle(.bordered)
            .accessibilityIdentifier("setup-reset-shared-state-button")
        }
    }

    private var setupReadinessPanel: some View {
        let presentation = setupReadiness
        return VStack(alignment: .leading, spacing: 8) {
            Label {
                VStack(alignment: .leading, spacing: 4) {
                    Text(presentation.title)
                        .font(.callout.weight(.semibold))
                    Text(presentation.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)
                }
            } icon: {
                Image(systemName: presentation.systemImage)
            }

            Text(presentation.nextAction)
                .font(.caption.weight(.semibold))
                .foregroundStyle(presentation.tone.color)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .accessibilityIdentifier("setup-readiness-next-action")
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(presentation.tone.color.opacity(0.10), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(presentation.tone.color.opacity(0.28))
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("setup-readiness-summary")
    }

    private var advancedRouteDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(FoilDictationLoopPresenter.advancedSupportPresentation()) { item in
                setupRow(title: item.title, detail: item.detail, systemImage: item.systemImage)
            }
            setupRow(
                title: "Support tools",
                detail: "Open Advanced / Support below for diagnostics, fake transcript staging, secure-field checks, and safe target notes.",
                systemImage: "chevron.down.circle"
            )
            readinessPanel
        }
    }

    private var readinessPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            statusRow(onboardingReadiness.detail, systemImage: onboardingReadiness.systemImage)
                .foregroundStyle(onboardingReadiness.isComplete ? .green : .primary)

            if !onboardingReadiness.blockers.isEmpty {
                ForEach(onboardingReadiness.blockers, id: \.self) { blocker in
                    Label(blocker, systemImage: "circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(10)
        .background(.background.opacity(0.55), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .accessibilityIdentifier(onboardingReadiness.isComplete ? "onboarding-ready" : "onboarding-not-ready")
    }

    @ViewBuilder
    private var diagnosticButtons: some View {
        Button {
            bridge.markListening()
            refresh()
        } label: {
            Label("Listening", systemImage: "waveform")
        }
        .buttonStyle(.bordered)
        .accessibilityIdentifier("mark-listening-button")

        Button {
            bridge.completeFakeTranscript()
            refresh()
        } label: {
            Label("Complete", systemImage: "checkmark.circle")
        }
        .buttonStyle(.borderedProminent)
        .accessibilityIdentifier("complete-fake-transcript-button")

        Button {
            bridge.reset()
            refresh()
        } label: {
            Label("Reset", systemImage: "arrow.counterclockwise")
        }
        .buttonStyle(.bordered)
        .accessibilityIdentifier("reset-keyboard-state-button")
    }

    @ViewBuilder
    private var keyboardRecoveryChecklist: some View {
        let steps = keyboardHealthPresentation.recoverySteps
        if !steps.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(steps, id: \.self) { step in
                    Label(step, systemImage: "checkmark.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityIdentifier("keyboard-recovery-checklist")
        }
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
            providerCredentialMessage = "Groq key saved"
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
        transcription.recoveryMessage != nil && audioCapture.lastRecordingURL != nil && !audioCapture.isRecording
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

    private var setupReadiness: FoilSetupReadinessPresentation {
        FoilDictationLoopPresenter.setupReadinessPresentation(
            hasProviderKey: transcription.hasConfiguredAPIKey,
            microphoneState: microphoneSetupState,
            keyboardHealth: keyboardHealth,
            snapshot: snapshot
        )
    }

    private var storageHealthSummary: String {
        if snapshot.transcript?.isEmpty == false {
            return "Transcript pending"
        }
        if snapshot.phase == .idle {
            return "Ready, no transcript"
        }
        return snapshot.phase.displayName
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
            recoveryMessage: recoveryMessage
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

    private func statusRow(_ text: String, systemImage: String) -> some View {
        Label {
            Text(text)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
        } icon: {
            Image(systemName: systemImage)
        }
    }

    private func setupRow(title: String, detail: String, systemImage: String) -> some View {
        Label {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.callout.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
            }
        } icon: {
            Image(systemName: systemImage)
        }
    }
}

private extension FoilLoopTone {
    var color: Color {
        switch self {
        case .ready:
            .accentColor
        case .live:
            .red
        case .working:
            .blue
        case .success:
            .green
        case .attention:
            .orange
        }
    }
}

#Preview {
    ContentView()
}
