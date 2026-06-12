import Foundation
import XCTest
@testable import FoilIOS

@MainActor
final class FoilProviderFailurePresentationTests: XCTestCase {
    func testControllerConfiguredStateUsesStoredKeyWithoutDisplayingIt() {
        let credentials = StubCredentialStore(storedKey: "gsk_fake_unit_test_key")
        let controller = TranscriptionController(
            client: StubTranscriptionProvider(result: .success("foil configured")),
            credentialStore: credentials,
            environment: [:]
        )

        XCTAssertTrue(controller.hasConfiguredAPIKey)
        XCTAssertEqual(controller.credentialSummary, "Groq key configured")
    }

    func testControllerMissingKeyStateIsActionable() async throws {
        let controller = TranscriptionController(
            client: StubTranscriptionProvider(result: .success("unused")),
            credentialStore: StubCredentialStore(storedKey: nil),
            environment: [:]
        )

        await controller.transcribeLatestRecording(try writeTemporaryAudioFile())

        XCTAssertEqual(controller.status, "Groq key needed")
        XCTAssertEqual(controller.recoveryMessage, "Save a Groq key, then tap Transcribe again.")
    }

    func testControllerInvalidKeyStateIsActionableWithoutLeakingKey() async throws {
        let controller = TranscriptionController(
            client: StubTranscriptionProvider(result: .failure(TranscriptionError.httpStatus(401))),
            credentialStore: StubCredentialStore(storedKey: "gsk_fake_unit_test_key"),
            environment: [:]
        )

        await controller.transcribeLatestRecording(try writeTemporaryAudioFile())

        XCTAssertEqual(controller.status, "Provider key rejected")
        XCTAssertEqual(controller.recoveryMessage, "Replace the Groq key, then tap Transcribe again.")
        XCTAssertFalse(controller.status.contains("gsk_"))
        XCTAssertFalse(controller.recoveryMessage?.contains("gsk_") == true)
    }

    func testControllerNetworkStateIsActionable() async throws {
        let controller = TranscriptionController(
            client: StubTranscriptionProvider(result: .failure(URLError(.timedOut))),
            credentialStore: StubCredentialStore(storedKey: "gsk_fake_unit_test_key"),
            environment: [:]
        )

        await controller.transcribeLatestRecording(try writeTemporaryAudioFile())

        XCTAssertEqual(controller.status, "Network unavailable")
        XCTAssertEqual(controller.recoveryMessage, "Check the connection, then tap Transcribe again.")
    }

    func testControllerTranscriptionQualityFailureIsRecoverable() async throws {
        let controller = TranscriptionController(
            client: StubTranscriptionProvider(result: .success("...")),
            credentialStore: StubCredentialStore(storedKey: "gsk_fake_unit_test_key"),
            environment: [:]
        )

        await controller.transcribeLatestRecording(try writeTemporaryAudioFile())

        XCTAssertEqual(controller.status, "No speech detected")
        XCTAssertEqual(controller.recoveryMessage, "Record again, or reset shared state to return the keyboard to ready.")
    }

    func testControllerRecoveredSuccessClearsRecoveryMessage() async throws {
        let controller = TranscriptionController(
            client: StubTranscriptionProvider(result: .success("foil recovered")),
            credentialStore: StubCredentialStore(storedKey: "gsk_fake_unit_test_key"),
            environment: [:]
        )

        await controller.transcribeLatestRecording(try writeTemporaryAudioFile())

        XCTAssertEqual(controller.status, "Transcription complete")
        XCTAssertNil(controller.recoveryMessage)
    }

    func testMissingKeyStateIsActionableWithoutSecretText() {
        let presentation = TranscriptionController.providerFailurePresentation(
            for: TranscriptionError.missingAPIKey
        )

        XCTAssertEqual(presentation.status, "Groq key needed")
        XCTAssertTrue(presentation.recoveryMessage.contains("Save a Groq key"))
        XCTAssertTrue(presentation.keyboardMessage.contains("Groq key needed"))
        assertDoesNotLeakSensitiveProviderText(presentation)
    }

    func testInvalidKeyStateAsksTesterToReplaceKey() {
        let presentation = TranscriptionController.providerFailurePresentation(
            for: TranscriptionError.httpStatus(401)
        )

        XCTAssertEqual(presentation.status, "Provider key rejected")
        XCTAssertTrue(presentation.recoveryMessage.contains("Replace the Groq key"))
        XCTAssertTrue(presentation.keyboardMessage.contains("update provider setup"))
        assertDoesNotLeakSensitiveProviderText(presentation)
    }

    func testForbiddenKeyStateUsesSameSafeInvalidKeyRecovery() {
        let presentation = TranscriptionController.providerFailurePresentation(
            for: TranscriptionError.httpStatus(403)
        )

        XCTAssertEqual(presentation.status, "Provider key rejected")
        XCTAssertTrue(presentation.recoveryMessage.contains("Replace the Groq key"))
        assertDoesNotLeakSensitiveProviderText(presentation)
    }

    func testProviderHTTPFailureIsRetryableWithoutBodyLeak() {
        let presentation = TranscriptionController.providerFailurePresentation(
            for: TranscriptionError.httpStatus(500)
        )

        XCTAssertEqual(presentation.status, "Provider error HTTP 500")
        XCTAssertTrue(presentation.recoveryMessage.contains("tap Transcribe again"))
        XCTAssertTrue(presentation.recoveryMessage.contains("provider status"))
        assertDoesNotLeakSensitiveProviderText(presentation)
    }

    func testNetworkFailureNamesConnectionRecovery() {
        let presentation = TranscriptionController.providerFailurePresentation(
            for: URLError(.notConnectedToInternet)
        )

        XCTAssertEqual(presentation.status, "Network unavailable")
        XCTAssertTrue(presentation.recoveryMessage.contains("Check the connection"))
        assertDoesNotLeakSensitiveProviderText(presentation)
    }

    func testInvalidProviderResponseIsReadableAndRecoverable() {
        let presentation = TranscriptionController.providerFailurePresentation(
            for: TranscriptionError.invalidResponse
        )

        XCTAssertEqual(presentation.status, "Provider response unreadable")
        XCTAssertTrue(presentation.recoveryMessage.contains("Tap Transcribe again"))
        XCTAssertTrue(presentation.keyboardMessage.contains("Open Foil"))
        assertDoesNotLeakSensitiveProviderText(presentation)
    }

    func testGenericFailureFallsBackWithoutLeakingLocalizedBody() {
        let presentation = TranscriptionController.providerFailurePresentation(
            for: ProviderSentinelError()
        )

        XCTAssertEqual(presentation.status, "Transcription failed")
        XCTAssertTrue(presentation.recoveryMessage.contains("Check the key or network"))
        assertDoesNotLeakSensitiveProviderText(presentation)
    }

    private func assertDoesNotLeakSensitiveProviderText(
        _ presentation: FoilProviderFailurePresentation,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let combined = [
            presentation.status,
            presentation.recoveryMessage,
            presentation.keyboardMessage
        ].joined(separator: " ")

        XCTAssertFalse(combined.contains("gsk_"), file: file, line: line)
        XCTAssertFalse(combined.contains("Bearer"), file: file, line: line)
        XCTAssertFalse(combined.contains("Authorization"), file: file, line: line)
        XCTAssertFalse(combined.contains("provider-body-sentinel"), file: file, line: line)
    }
}

private func writeTemporaryAudioFile() throws -> URL {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent("FoilProviderFailurePresentationTests-\(UUID().uuidString)", isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let url = directory.appendingPathComponent("sample.m4a")
    try Data("voice".utf8).write(to: url)
    return url
}

private struct StubTranscriptionProvider: FoilTranscriptionProviding {
    var result: Result<String, Error>

    func transcribe(audioFileURL: URL, apiKey: String) async throws -> String {
        try result.get()
    }
}

private final class StubCredentialStore: FoilCredentialProviding {
    private var storedKey: String?

    init(storedKey: String?) {
        self.storedKey = storedKey
    }

    func loadGroqAPIKey() -> String? {
        storedKey
    }

    func saveGroqAPIKey(_ value: String) throws {
        storedKey = value
    }

    func clearGroqAPIKey() throws {
        storedKey = nil
    }
}

private struct ProviderSentinelError: LocalizedError {
    var errorDescription: String? {
        "provider-body-sentinel gsk_fake_secret"
    }
}
