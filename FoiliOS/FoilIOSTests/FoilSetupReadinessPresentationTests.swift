import XCTest
@testable import FoilIOS

final class FoilSetupReadinessPresentationTests: XCTestCase {
    func testSetupReadinessFirstRunPrioritizesProviderKey() {
        let presentation = FoilDictationLoopPresenter.setupReadinessPresentation(
            hasProviderKey: false,
            microphoneState: .needsPrompt,
            keyboardHealth: .initial,
            snapshot: .initial
        )

        XCTAssertEqual(presentation.title, "Setup not started")
        XCTAssertTrue(presentation.detail.contains("Groq provider key"))
        XCTAssertTrue(presentation.detail.contains("verified only after a successful transcription"))
        XCTAssertTrue(presentation.nextAction.contains("Save key"))
        XCTAssertEqual(presentation.tone, .attention)
    }

    func testSetupReadinessPartialStateExplainsMicrophonePrompt() {
        let presentation = FoilDictationLoopPresenter.setupReadinessPresentation(
            hasProviderKey: true,
            microphoneState: .needsPrompt,
            keyboardHealth: .initial,
            snapshot: .initial
        )

        XCTAssertEqual(presentation.title, "Ready for microphone prompt")
        XCTAssertTrue(presentation.detail.contains("Provider key is saved on this iPhone"))
        XCTAssertTrue(presentation.detail.contains("verify it when transcription succeeds"))
        XCTAssertTrue(presentation.nextAction.contains("allow microphone access"))
        XCTAssertEqual(presentation.tone, .ready)
    }

    func testSetupReadinessBlockedKeyboardExplainsFullAccessRecovery() {
        let presentation = FoilDictationLoopPresenter.setupReadinessPresentation(
            hasProviderKey: true,
            microphoneState: .allowed,
            keyboardHealth: FoilKeyboardHealthReport(
                fullAccessState: .disabled,
                snapshotPhase: .idle,
                snapshotHasTranscript: false,
                message: "Allow Full Access required",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            snapshot: .initial,
            now: Date(timeIntervalSince1970: 101)
        )

        XCTAssertEqual(presentation.title, "Keyboard blocked")
        XCTAssertTrue(presentation.detail.contains("Allow Full Access is off"))
        XCTAssertTrue(presentation.nextAction.contains("Settings > General > Keyboard"))
        XCTAssertEqual(presentation.tone, .attention)
    }

    func testSetupReadinessStaleKeyboardAsksTesterToRefresh() {
        let presentation = FoilDictationLoopPresenter.setupReadinessPresentation(
            hasProviderKey: true,
            microphoneState: .allowed,
            keyboardHealth: FoilKeyboardHealthReport(
                fullAccessState: .enabled,
                snapshotPhase: .idle,
                snapshotHasTranscript: false,
                message: "Foil Keyboard verified",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            snapshot: .initial,
            now: Date(timeIntervalSince1970: 300)
        )

        XCTAssertEqual(presentation.title, "Refresh keyboard")
        XCTAssertTrue(presentation.detail.contains("not checked in recently"))
        XCTAssertTrue(presentation.nextAction.contains("Tap the target text field"))
        XCTAssertEqual(presentation.tone, .attention)
    }

    func testSetupReadinessCompleteStateKeepsClosedBetaScopeNarrow() {
        let presentation = FoilDictationLoopPresenter.setupReadinessPresentation(
            hasProviderKey: true,
            microphoneState: .allowed,
            keyboardHealth: FoilKeyboardHealthReport(
                fullAccessState: .enabled,
                snapshotPhase: .idle,
                snapshotHasTranscript: false,
                message: "Foil Keyboard verified",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            snapshot: .initial,
            now: Date(timeIntervalSince1970: 101)
        )

        let combined = "\(presentation.title) \(presentation.detail) \(presentation.nextAction)"
        XCTAssertEqual(presentation.title, "Setup ready")
        XCTAssertTrue(combined.contains("Provider verification still depends on a successful transcription"))
        XCTAssertTrue(combined.contains("narrow closed beta loop"))
        XCTAssertTrue(combined.contains("safe text field"))
        XCTAssertFalse(combined.contains("Mail support"))
        XCTAssertFalse(combined.contains("Messages delivery"))
        XCTAssertFalse(combined.contains("broad iPhone app support"))
        XCTAssertEqual(presentation.tone, .success)
    }

    func testSetupReadinessReadyToInsertPointsBackToKeyboardOnce() {
        let presentation = FoilDictationLoopPresenter.setupReadinessPresentation(
            hasProviderKey: true,
            microphoneState: .allowed,
            keyboardHealth: FoilKeyboardHealthReport(
                fullAccessState: .enabled,
                snapshotPhase: .complete,
                snapshotHasTranscript: true,
                message: "Foil Keyboard verified",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            snapshot: FoilKeyboardSnapshot(
                phase: .complete,
                transcript: "Foil beta test",
                message: "Groq transcript ready.",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            now: Date(timeIntervalSince1970: 101)
        )

        XCTAssertEqual(presentation.title, "Ready to insert")
        XCTAssertTrue(presentation.nextAction.contains("Insert latest once"))
        XCTAssertEqual(presentation.tone, .success)
    }
}
