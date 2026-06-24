import XCTest
@testable import FoilIOS

final class FoilKeyboardLoopPresentationTests: XCTestCase {
    func testKeyboardIdleStateExplainsHandoffInsteadOfSayingNoTranscriptOnly() {
        let presentation = FoilDictationLoopPresenter.keyboardPresentation(
            snapshot: .initial,
            fullAccessEnabled: true
        )

        XCTAssertEqual(presentation.status, "Ready to dictate")
        XCTAssertEqual(presentation.insertTitle, "No transcript to insert")
        XCTAssertEqual(presentation.startTitle, "Dictate in Foil")
        XCTAssertTrue(presentation.message.contains("record in the app"))
    }

    func testKeyboardFailureStatePointsBackToFoilForRecovery() {
        let presentation = FoilDictationLoopPresenter.keyboardPresentation(
            snapshot: FoilKeyboardSnapshot(
                phase: .failed,
                transcript: nil,
                message: "No speech detected. Record again in Foil.",
                updatedAt: Date()
            ),
            fullAccessEnabled: true
        )

        XCTAssertEqual(presentation.status, "Try again in Foil")
        XCTAssertEqual(presentation.startTitle, "Record again in Foil")
        XCTAssertEqual(presentation.insertTitle, "No insertable transcript")
        XCTAssertTrue(presentation.message.contains("No speech detected"))
        XCTAssertTrue(presentation.message.contains("Open Foil"))
    }

    func testKeyboardNonCompleteLeftoverTranscriptDoesNotAdvertiseInsertLatest() {
        let snapshots = [
            FoilKeyboardSnapshot(
                phase: .idle,
                transcript: "leftover transcript",
                message: "Ready",
                updatedAt: Date()
            ),
            FoilKeyboardSnapshot(
                phase: .handoffRequested,
                transcript: "leftover transcript",
                message: "Foil is opening.",
                updatedAt: Date()
            ),
            FoilKeyboardSnapshot(
                phase: .listening,
                transcript: "leftover transcript",
                message: "Recording.",
                updatedAt: Date()
            ),
            FoilKeyboardSnapshot(
                phase: .processing,
                transcript: "leftover transcript",
                message: "Transcribing.",
                updatedAt: Date()
            ),
            FoilKeyboardSnapshot(
                phase: .failed,
                transcript: "leftover transcript",
                message: "No speech detected.",
                updatedAt: Date()
            )
        ]

        for snapshot in snapshots {
            let presentation = FoilDictationLoopPresenter.keyboardPresentation(
                snapshot: snapshot,
                fullAccessEnabled: true
            )

            XCTAssertNotEqual(presentation.insertTitle, "Insert latest", "Expected \(snapshot.phase.rawValue) to be non-insertable.")
            XCTAssertFalse(presentation.status.contains("Transcript ready"), "Expected \(snapshot.phase.rawValue) not to present a ready transcript.")
        }
    }

    func testKeyboardStaleCompleteTranscriptDoesNotAdvertiseInsertLatest() {
        let presentation = FoilDictationLoopPresenter.keyboardPresentation(
            snapshot: FoilKeyboardSnapshot(
                phase: .complete,
                transcript: "older transcript",
                message: "Ready",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            fullAccessEnabled: true,
            now: Date(timeIntervalSince1970: 500),
            staleAfter: 120
        )

        XCTAssertEqual(presentation.status, "Transcript may be stale")
        XCTAssertEqual(presentation.insertTitle, "Stale transcript")
        XCTAssertEqual(presentation.clearTitle, "Clear stale transcript")
        XCTAssertTrue(presentation.message.contains("Clear stale transcript"))
        XCTAssertTrue(presentation.message.contains("record again in Foil"))
        XCTAssertFalse(presentation.message.contains("Insert latest"))
    }

    func testKeyboardCompleteStateSaysInsertOnceAndContinueTyping() {
        let presentation = FoilDictationLoopPresenter.keyboardPresentation(
            snapshot: FoilKeyboardSnapshot(
                phase: .complete,
                transcript: "ready transcript",
                message: "Ready",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            fullAccessEnabled: true,
            now: Date(timeIntervalSince1970: 110),
            staleAfter: 120
        )

        XCTAssertEqual(presentation.status, "Transcript ready")
        XCTAssertEqual(presentation.insertTitle, "Insert latest")
        XCTAssertTrue(presentation.message.contains("Insert latest once"))
        XCTAssertTrue(presentation.message.contains("switch keyboards"))
    }

    func testKeyboardNonInsertableStatesExplainWhyInsertIsUnavailable() {
        let cases: [(FoilKeyboardPhase, String, String)] = [
            (.handoffRequested, "Finish in Foil", "Finish recording"),
            (.listening, "Finish in Foil", "Finish recording"),
            (.processing, "Waiting for transcript", "preparing text")
        ]

        for (phase, insertTitle, messageFragment) in cases {
            let presentation = FoilDictationLoopPresenter.keyboardPresentation(
                snapshot: FoilKeyboardSnapshot(
                    phase: phase,
                    transcript: nil,
                    message: phase.displayName,
                    updatedAt: Date()
                ),
                fullAccessEnabled: true
            )

            XCTAssertEqual(presentation.insertTitle, insertTitle, "Unexpected insert title for \(phase.rawValue)")
            XCTAssertTrue(presentation.message.contains(messageFragment), "Expected \(phase.rawValue) to explain \(messageFragment)")
        }
    }

    func testKeyboardAgedProcessingExplainsRecoveryAndStaysNonInsertable() {
        let presentation = FoilDictationLoopPresenter.keyboardPresentation(
            snapshot: FoilKeyboardSnapshot(
                phase: .processing,
                transcript: nil,
                message: "Transcribing",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            fullAccessEnabled: true,
            now: Date(timeIntervalSince1970: 250)
        )

        XCTAssertEqual(presentation.status, "Processing may be stuck")
        XCTAssertEqual(presentation.insertTitle, "Waiting for transcript")
        XCTAssertEqual(presentation.clearTitle, "Clear stuck processing")
        XCTAssertTrue(presentation.message.contains("Nothing can be inserted yet"))
    }
}
