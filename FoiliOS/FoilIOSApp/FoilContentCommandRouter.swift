import Foundation

@MainActor
struct FoilContentCommandRouter {
    static func handleOpenURL(
        _ url: URL,
        bridge: FoilKeyboardBridge,
        audioCapture: AudioCaptureController,
        transcription: TranscriptionController,
        refresh: () -> Void
    ) {
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

    static func handlePendingCommand(
        bridge: FoilKeyboardBridge,
        lastHandledCommandID: inout String?,
        audioCapture: AudioCaptureController,
        transcription: TranscriptionController,
        refresh: () -> Void
    ) {
        guard let command = bridge.loadCommand(),
              command.id != lastHandledCommandID else {
            return
        }

        lastHandledCommandID = command.id
        bridge.clearCommand()
        perform(command.action, bridge: bridge, audioCapture: audioCapture, transcription: transcription, refresh: refresh)
    }

    static func perform(
        _ action: FoilAppPrimaryAction,
        bridge: FoilKeyboardBridge,
        audioCapture: AudioCaptureController,
        transcription: TranscriptionController,
        refresh: () -> Void
    ) {
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

    static func perform(
        _ action: FoilAppSecondaryAction,
        audioCapture: AudioCaptureController,
        refresh: () -> Void
    ) {
        switch action {
        case .cancelRecording:
            audioCapture.cancelRecording()
            refresh()
        }
    }

    private static func perform(
        _ action: FoilIOSCommandAction,
        bridge: FoilKeyboardBridge,
        audioCapture: AudioCaptureController,
        transcription: TranscriptionController,
        refresh: () -> Void
    ) {
        switch action {
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
}
