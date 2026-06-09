import Foundation

@MainActor
final class TranscriptionController: ObservableObject {
    @Published private(set) var status = "Transcription idle"
    @Published private(set) var recoveryMessage: String?

    private let bridge = FoilKeyboardBridge()
    private let client: any FoilTranscriptionProviding
    private let credentialStore: any FoilCredentialProviding
    private let environment: [String: String]

    init(
        client: any FoilTranscriptionProviding = FoilTranscriptionClient(),
        credentialStore: any FoilCredentialProviding = FoilCredentialStore.shared,
        environment: [String: String] = ProcessInfo.processInfo.environment
    ) {
        self.client = client
        self.credentialStore = credentialStore
        self.environment = environment
    }

    var hasConfiguredAPIKey: Bool {
        apiKey != nil
    }

    var credentialSummary: String {
        hasConfiguredAPIKey ? "Groq key configured" : "Groq key needed"
    }

    func saveGroqAPIKey(_ value: String) throws {
        try credentialStore.saveGroqAPIKey(value)
        objectWillChange.send()
    }

    func clearGroqAPIKey() throws {
        try credentialStore.clearGroqAPIKey()
        objectWillChange.send()
    }

    func transcribeLatestRecording(_ recordingURL: URL?) async {
        guard let recordingURL else {
            status = TranscriptionError.missingRecording.localizedDescription
            recoveryMessage = "Record first, then tap Transcribe."
            return
        }
        guard let apiKey else {
            status = TranscriptionError.missingAPIKey.localizedDescription
            recoveryMessage = "Save a Groq key, then tap Transcribe again."
            bridge.fail(message: "Groq key needed. Open Foil app to recover.")
            return
        }

        status = "Transcribing"
        recoveryMessage = nil
        bridge.save(
            FoilKeyboardSnapshot(
                phase: .processing,
                transcript: nil,
                message: "Transcribing with Groq. Return when the transcript is ready.",
                updatedAt: Date()
            )
        )

        do {
            let transcript = try await client.transcribe(audioFileURL: recordingURL, apiKey: apiKey)
            guard FoilTranscriptQuality.isAcceptable(transcript) else {
                status = "No speech detected"
                recoveryMessage = "Record again, or reset shared state to return the keyboard to ready."
                bridge.fail(message: "No speech detected. Record again in Foil.")
                return
            }
            let finalTranscript = transcript
            status = "Transcription complete"
            recoveryMessage = nil
            bridge.complete(transcript: finalTranscript, message: "Groq transcript ready. Switch back and tap Insert latest.")
        } catch {
            let presentation = Self.providerFailurePresentation(for: error)
            status = presentation.status
            recoveryMessage = presentation.recoveryMessage
            bridge.fail(message: presentation.keyboardMessage)
        }
    }

    static func providerFailurePresentation(for error: Error) -> FoilProviderFailurePresentation {
        if let transcriptionError = error as? TranscriptionError {
            switch transcriptionError {
            case .httpStatus(401), .httpStatus(403):
                return FoilProviderFailurePresentation(
                    status: "Provider key rejected",
                    recoveryMessage: "Replace the Groq key, then tap Transcribe again.",
                    keyboardMessage: "Groq key rejected. Open Foil app to update provider setup."
                )
            case .httpStatus(let status):
                return FoilProviderFailurePresentation(
                    status: "Provider error HTTP \(status)",
                    recoveryMessage: "Wait a moment, then tap Transcribe again. If this repeats, check provider status.",
                    keyboardMessage: "Provider error. Open Foil app to retry."
                )
            case .invalidResponse:
                return FoilProviderFailurePresentation(
                    status: "Provider response unreadable",
                    recoveryMessage: "Tap Transcribe again. If this repeats, reset shared state and record again.",
                    keyboardMessage: "Provider response unreadable. Open Foil app to retry."
                )
            case .missingAPIKey:
                return FoilProviderFailurePresentation(
                    status: TranscriptionError.missingAPIKey.localizedDescription,
                    recoveryMessage: "Save a Groq key, then tap Transcribe again.",
                    keyboardMessage: "Groq key needed. Open Foil app to recover."
                )
            case .missingRecording:
                return FoilProviderFailurePresentation(
                    status: TranscriptionError.missingRecording.localizedDescription,
                    recoveryMessage: "Record first, then tap Transcribe.",
                    keyboardMessage: "Recording needed. Open Foil app to recover."
                )
            }
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotFindHost, .cannotConnectToHost:
                return FoilProviderFailurePresentation(
                    status: "Network unavailable",
                    recoveryMessage: "Check the connection, then tap Transcribe again.",
                    keyboardMessage: "Network unavailable. Open Foil app to retry."
                )
            default:
                return FoilProviderFailurePresentation(
                    status: "Network request failed",
                    recoveryMessage: "Check the connection or provider status, then tap Transcribe again.",
                    keyboardMessage: "Network request failed. Open Foil app to retry."
                )
            }
        }

        return FoilProviderFailurePresentation(
            status: "Transcription failed",
            recoveryMessage: "Check the key or network, then tap Transcribe again.",
            keyboardMessage: "Transcription failed. Open Foil app to retry."
        )
    }

    private var apiKey: String? {
        if let environmentKey = nonEmpty(environment["FOIL_IOS_GROQ_API_KEY"]) {
            return environmentKey
        }
        if let environmentKey = nonEmpty(environment["GROQ_API_KEY"]) {
            return environmentKey
        }
        if let storedKey = credentialStore.loadGroqAPIKey() {
            return storedKey
        }

        #if DEBUG
        return nonEmpty(UserDefaults.standard.string(forKey: "FOIL_IOS_GROQ_API_KEY"))
            ?? nonEmpty(UserDefaults.standard.string(forKey: "GROQ_API_KEY"))
        #else
        return nil
        #endif
    }

    private func nonEmpty(_ value: String?) -> String? {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else {
            return nil
        }
        return value
    }
}

struct FoilProviderFailurePresentation: Equatable {
    var status: String
    var recoveryMessage: String
    var keyboardMessage: String
}
