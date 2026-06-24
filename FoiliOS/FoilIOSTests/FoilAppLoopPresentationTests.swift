import XCTest
@testable import FoilIOS

final class FoilAppLoopPresentationTests: XCTestCase {
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
        XCTAssertTrue(presentation.detail.contains("return to the target field"))
        XCTAssertTrue(presentation.detail.contains("switch to Foil Keyboard"))
        XCTAssertTrue(presentation.detail.contains("insert once"))
    }

    func testSetupLeadsWhenSetupIsNotReadyAndNoDictationIsActive() {
        let readiness = FoilOnboardingReadinessPresentation(
            title: "Finish setup",
            detail: "Setup is not ready.",
            systemImage: "exclamationmark.circle.fill",
            isComplete: false,
            blockers: ["Save an API key on this iPhone."]
        )

        XCTAssertTrue(
            FoilDictationLoopPresenter.shouldPrioritizeSetup(
                onboardingReadiness: readiness,
                snapshot: .initial,
                isRecording: false,
                hasSavedRecording: false,
                isTranscribing: false
            )
        )
    }

    func testSetupDoesNotLeadWhenSetupIsReadyOrDictationIsActive() {
        let ready = FoilOnboardingReadinessPresentation(
            title: "Ready to dictate and insert",
            detail: "Setup is ready.",
            systemImage: "checkmark.circle.fill",
            isComplete: true,
            blockers: []
        )
        let notReady = FoilOnboardingReadinessPresentation(
            title: "Finish setup",
            detail: "Setup is not ready.",
            systemImage: "exclamationmark.circle.fill",
            isComplete: false,
            blockers: ["Verify Foil Keyboard."]
        )

        XCTAssertFalse(
            FoilDictationLoopPresenter.shouldPrioritizeSetup(
                onboardingReadiness: ready,
                snapshot: .initial,
                isRecording: false,
                hasSavedRecording: false,
                isTranscribing: false
            )
        )
        XCTAssertFalse(
            FoilDictationLoopPresenter.shouldPrioritizeSetup(
                onboardingReadiness: notReady,
                snapshot: .initial,
                isRecording: true,
                hasSavedRecording: false,
                isTranscribing: false
            )
        )
        XCTAssertFalse(
            FoilDictationLoopPresenter.shouldPrioritizeSetup(
                onboardingReadiness: notReady,
                snapshot: .initial,
                isRecording: false,
                hasSavedRecording: true,
                isTranscribing: false
            )
        )
        XCTAssertFalse(
            FoilDictationLoopPresenter.shouldPrioritizeSetup(
                onboardingReadiness: notReady,
                snapshot: FoilKeyboardSnapshot(
                    phase: .processing,
                    transcript: nil,
                    message: "Transcribing.",
                    updatedAt: Date()
                ),
                isRecording: false,
                hasSavedRecording: false,
                isTranscribing: false
            )
        )
        XCTAssertFalse(
            FoilDictationLoopPresenter.shouldPrioritizeSetup(
                onboardingReadiness: notReady,
                snapshot: FoilKeyboardSnapshot(
                    phase: .complete,
                    transcript: "ready text",
                    message: "Ready.",
                    updatedAt: Date()
                ),
                isRecording: false,
                hasSavedRecording: false,
                isTranscribing: false
            )
        )
    }

    func testRecordingStateOffersFinishAndCancelActions() {
        let presentation = FoilDictationLoopPresenter.appPresentation(
            snapshot: .initial,
            isRecording: true,
            hasSavedRecording: false,
            isTranscribing: false,
            recoveryMessage: nil
        )

        XCTAssertEqual(presentation.primaryAction, .stopRecording)
        XCTAssertEqual(presentation.secondaryAction, .cancelRecording)
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
        XCTAssertTrue(presentation.detail.contains("Return to your target field"))
        XCTAssertTrue(presentation.detail.contains("switch to Foil Keyboard"))
        XCTAssertTrue(presentation.detail.contains("Insert latest once"))
        XCTAssertTrue(presentation.detail.contains("Tested targets"))
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

    func testAppAgedProcessingOffersRecoveryWithoutInsertability() {
        let presentation = FoilDictationLoopPresenter.appPresentation(
            snapshot: FoilKeyboardSnapshot(
                phase: .processing,
                transcript: nil,
                message: "Transcribing",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            isRecording: false,
            hasSavedRecording: true,
            isTranscribing: false,
            recoveryMessage: nil,
            now: Date(timeIntervalSince1970: 250)
        )

        XCTAssertEqual(presentation.title, "Processing may be stuck")
        XCTAssertEqual(presentation.primaryAction, .retryTranscript)
        XCTAssertTrue(presentation.detail.contains("longer than expected"))

        let waiting = FoilDictationLoopPresenter.appPresentation(
            snapshot: FoilKeyboardSnapshot(
                phase: .processing,
                transcript: nil,
                message: "Transcribing",
                updatedAt: Date(timeIntervalSince1970: 200)
            ),
            isRecording: false,
            hasSavedRecording: true,
            isTranscribing: true,
            recoveryMessage: nil,
            now: Date(timeIntervalSince1970: 250)
        )

        XCTAssertEqual(waiting.title, "Creating transcript")
        XCTAssertNil(waiting.primaryAction)
    }

    func testAppProviderKeyFailureDoesNotOfferRetryAsPrimaryRecovery() {
        let presentation = FoilDictationLoopPresenter.appPresentation(
            snapshot: FoilKeyboardSnapshot(
                phase: .failed,
                transcript: nil,
                message: "Groq key rejected. Open Foil app to update provider key.",
                updatedAt: Date()
            ),
            isRecording: false,
            hasSavedRecording: true,
            isTranscribing: false,
            recoveryMessage: "Replace the saved Groq key below, then tap Transcribe again.",
            providerRecoveryRequiresKeyUpdate: true
        )

        XCTAssertEqual(presentation.title, "Update provider key")
        XCTAssertEqual(presentation.badge, "Provider")
        XCTAssertNil(presentation.primaryAction)
        XCTAssertTrue(presentation.detail.contains("Replace the saved Groq key"))
    }
}
