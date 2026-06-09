import XCTest
@testable import FoilIOS

final class FoilDictationLoopPresentationTests: XCTestCase {
    func testSetupReadinessFirstRunPrioritizesProviderKey() {
        let presentation = FoilDictationLoopPresenter.setupReadinessPresentation(
            hasProviderKey: false,
            microphoneState: .needsPrompt,
            keyboardHealth: .initial,
            snapshot: .initial
        )

        XCTAssertEqual(presentation.title, "Setup not started")
        XCTAssertTrue(presentation.detail.contains("Groq provider key"))
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
        XCTAssertTrue(presentation.detail.contains("Provider is saved"))
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

    func testSetupChecklistCoversClosedBetaJourneyInOrder() {
        let items = FoilDictationLoopPresenter.setupChecklistPresentation()

        XCTAssertEqual(
            items.map(\.title),
            [
                "Provider key",
                "Microphone",
                "Add Foil Keyboard",
                "Allow Full Access",
                "Record in Foil",
                "Return and insert",
                "Reset when stale"
            ]
        )
        XCTAssertTrue(items[0].detail.contains("Save"))
        XCTAssertTrue(items[1].detail.contains("Allow microphone"))
        XCTAssertTrue(items[2].detail.contains("Settings > General > Keyboard"))
        XCTAssertTrue(items[3].detail.contains("read and clear shared dictation state"))
        XCTAssertTrue(items[4].detail.contains("Create transcript"))
        XCTAssertTrue(items[5].detail.contains("Insert latest once"))
        XCTAssertTrue(items[6].detail.contains("Reset shared state"))
    }

    func testBetaGuidanceNamesSafeTargetsAndClaimBoundaries() {
        let items = FoilDictationLoopPresenter.betaGuidancePresentation()
        let combined = items.map { "\($0.title) \($0.detail)" }.joined(separator: " ")

        XCTAssertTrue(combined.contains("Notes"))
        XCTAssertTrue(combined.contains("Safari"))
        XCTAssertTrue(combined.contains("Messages draft"))
        XCTAssertTrue(combined.contains("Do not send"))
        XCTAssertTrue(combined.contains("Mail is deferred"))
        XCTAssertTrue(combined.contains("Secure fields should reject Foil Keyboard"))
        XCTAssertTrue(combined.contains("not broad iPhone app support"))
    }

    func testAppReadyStateTellsUserToRecordInFoilAndReturnToKeyboard() {
        let presentation = FoilDictationLoopPresenter.appPresentation(
            snapshot: .initial,
            isRecording: false,
            hasSavedRecording: false,
            isTranscribing: false,
            recoveryMessage: nil
        )

        XCTAssertEqual(presentation.title, "Record in Foil")
        XCTAssertEqual(presentation.primaryAction, .record)
        XCTAssertTrue(presentation.detail.contains("Return to your keyboard"))
    }

    func testAppCompleteStatePointsBackToTargetAppAndKeyboardInsert() {
        let presentation = FoilDictationLoopPresenter.appPresentation(
            snapshot: FoilKeyboardSnapshot(
                phase: .complete,
                transcript: "hello foil",
                message: "Groq transcript ready.",
                updatedAt: Date()
            ),
            isRecording: false,
            hasSavedRecording: true,
            isTranscribing: false,
            recoveryMessage: nil
        )

        XCTAssertEqual(presentation.title, "Ready for keyboard")
        XCTAssertNil(presentation.primaryAction)
        XCTAssertTrue(presentation.detail.contains("Return to the text field"))
        XCTAssertTrue(presentation.detail.contains("Insert latest"))
    }

    func testTranscriptReviewShowsBodyAndRetryOptionsWhenTranscriptIsReady() {
        let presentation = FoilDictationLoopPresenter.transcriptReviewPresentation(
            snapshot: FoilKeyboardSnapshot(
                phase: .complete,
                transcript: "Foil audio smoke test.",
                message: "Groq transcript ready.",
                updatedAt: Date()
            ),
            hasSavedRecording: true
        )

        XCTAssertEqual(presentation?.transcript, "Foil audio smoke test.")
        XCTAssertEqual(presentation?.guidance, "Review before inserting. If this looks wrong, retry the recording or reset and record again.")
        XCTAssertEqual(presentation?.retryTitle, "Retry recording")
        XCTAssertEqual(presentation?.resetTitle, "Reset and record again")
        XCTAssertTrue(presentation?.canRetryRecording == true)
    }

    func testTranscriptReviewIsHiddenWhenNoTranscriptIsReady() {
        let presentation = FoilDictationLoopPresenter.transcriptReviewPresentation(
            snapshot: .initial,
            hasSavedRecording: false
        )

        XCTAssertNil(presentation)
    }

    func testAppFailureStateOffersRetryWhenRecordingExists() {
        let presentation = FoilDictationLoopPresenter.appPresentation(
            snapshot: FoilKeyboardSnapshot(
                phase: .failed,
                transcript: nil,
                message: "No speech detected. Record again in Foil.",
                updatedAt: Date()
            ),
            isRecording: false,
            hasSavedRecording: true,
            isTranscribing: false,
            recoveryMessage: "No speech detected. Record again, then return to the keyboard."
        )

        XCTAssertEqual(presentation.title, "Try again")
        XCTAssertEqual(presentation.primaryAction, .retryTranscript)
        XCTAssertTrue(presentation.detail.contains("No speech detected"))
    }

    func testKeyboardIdleStateExplainsHandoffInsteadOfSayingNoTranscriptOnly() {
        let presentation = FoilDictationLoopPresenter.keyboardPresentation(
            snapshot: .initial,
            fullAccessEnabled: true
        )

        XCTAssertEqual(presentation.status, "Ready to dictate")
        XCTAssertEqual(presentation.insertTitle, "No transcript yet")
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

    func testKeyboardFullAccessOffTellsUserToEnableAndCycleBack() {
        let presentation = FoilDictationLoopPresenter.keyboardPresentation(
            snapshot: .initial,
            fullAccessEnabled: false
        )

        XCTAssertEqual(presentation.status, "Open Foil")
        XCTAssertEqual(presentation.insertTitle, "Insert unavailable")
        XCTAssertTrue(presentation.message.contains("Allow Full Access"))
        XCTAssertTrue(presentation.message.contains("cycle back"))
    }

    func testKeyboardHealthPresentationDetectsUnverifiedState() {
        let presentation = FoilDictationLoopPresenter.keyboardHealthPresentation(
            report: .initial,
            now: Date(timeIntervalSince1970: 500)
        )

        XCTAssertTrue(presentation.detail.contains("Open Foil Keyboard"))
        XCTAssertEqual(presentation.recoveryMessage, presentation.detail)
        XCTAssertEqual(presentation.recoverySteps.count, 3)
        XCTAssertTrue(presentation.recoverySteps[1].contains("Switch to Foil Keyboard"))
    }

    func testKeyboardHealthPresentationPrioritizesFullAccessOff() {
        let report = FoilKeyboardHealthReport(
            fullAccessState: .disabled,
            snapshotPhase: .complete,
            snapshotHasTranscript: true,
            message: "Allow Full Access required",
            updatedAt: Date(timeIntervalSince1970: 100)
        )

        let presentation = FoilDictationLoopPresenter.keyboardHealthPresentation(
            report: report,
            now: Date(timeIntervalSince1970: 101)
        )

        XCTAssertTrue(presentation.detail.contains("Allow Full Access is off"))
        XCTAssertTrue(presentation.detail.contains("reopen Foil Keyboard"))
        XCTAssertEqual(presentation.recoveryMessage, presentation.detail)
        XCTAssertEqual(presentation.recoverySteps.count, 3)
        XCTAssertTrue(presentation.recoverySteps[1].contains("enable Allow Full Access"))
    }

    func testKeyboardHealthPresentationDetectsStaleEnabledKeyboard() {
        let report = FoilKeyboardHealthReport(
            fullAccessState: .enabled,
            snapshotPhase: .idle,
            snapshotHasTranscript: false,
            message: "Foil Keyboard verified",
            updatedAt: Date(timeIntervalSince1970: 100)
        )

        let presentation = FoilDictationLoopPresenter.keyboardHealthPresentation(
            report: report,
            now: Date(timeIntervalSince1970: 300),
            staleAfter: 120
        )

        XCTAssertTrue(presentation.detail.contains("not checked in recently"))
        XCTAssertTrue(presentation.detail.contains("cycle back"))
        XCTAssertEqual(presentation.recoveryMessage, presentation.detail)
        XCTAssertEqual(presentation.recoverySteps.count, 3)
        XCTAssertTrue(presentation.recoverySteps[1].contains("Switch away"))
    }

    func testKeyboardHealthPresentationKeepsFreshEnabledStateQuiet() {
        let report = FoilKeyboardHealthReport(
            fullAccessState: .enabled,
            snapshotPhase: .complete,
            snapshotHasTranscript: true,
            message: "Foil Keyboard verified",
            updatedAt: Date(timeIntervalSince1970: 100)
        )

        let presentation = FoilDictationLoopPresenter.keyboardHealthPresentation(
            report: report,
            now: Date(timeIntervalSince1970: 110),
            staleAfter: 120
        )

        XCTAssertEqual(presentation.detail, "Full Access on, transcript waiting in keyboard.")
        XCTAssertNil(presentation.recoveryMessage)
        XCTAssertTrue(presentation.recoverySteps.isEmpty)
    }
}
