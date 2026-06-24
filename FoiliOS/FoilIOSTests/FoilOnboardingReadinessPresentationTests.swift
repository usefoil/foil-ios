import XCTest
@testable import FoilIOS

final class FoilOnboardingReadinessPresentationTests: XCTestCase {
    func testOnboardingReadinessDoesNotCompleteWhenAnyInsertionGateIsMissing() {
        let freshEnabledHealth = FoilKeyboardHealthReport(
            fullAccessState: .enabled,
            snapshotPhase: .idle,
            snapshotHasTranscript: false,
            message: "Foil Keyboard verified",
            updatedAt: Date(timeIntervalSince1970: 100)
        )
        let healthyStorage = FoilKeyboardStorageReport(
            operation: "save",
            phase: .idle,
            hasTranscript: false,
            canonicalPath: "/tmp/foil-keyboard-snapshot.json",
            canonicalWriteSucceeded: true,
            canonicalWriteError: nil,
            canonicalVerificationPhase: .idle,
            canonicalVerificationHasTranscript: false,
            defaultsWriteAttempted: true,
            fallbackRemovalResults: [],
            updatedAt: Date(timeIntervalSince1970: 100)
        )

        let missingKey = FoilDictationLoopPresenter.onboardingReadinessPresentation(
            selectedRouteID: "iphone-api-key",
            hasConfiguredAPIKey: false,
            microphoneAllowed: true,
            keyboardHealth: freshEnabledHealth,
            storageReport: healthyStorage,
            snapshot: .initial,
            now: Date(timeIntervalSince1970: 110)
        )
        XCTAssertFalse(missingKey.isComplete)
        XCTAssertTrue(missingKey.blockers.contains("Save an API key on this iPhone."))

        let fullAccessOff = FoilDictationLoopPresenter.onboardingReadinessPresentation(
            selectedRouteID: "iphone-api-key",
            hasConfiguredAPIKey: true,
            microphoneAllowed: true,
            keyboardHealth: FoilKeyboardHealthReport(
                fullAccessState: .disabled,
                snapshotPhase: .idle,
                snapshotHasTranscript: false,
                message: "Allow Full Access required",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            storageReport: healthyStorage,
            snapshot: .initial,
            now: Date(timeIntervalSince1970: 110)
        )
        XCTAssertFalse(fullAccessOff.isComplete)
        XCTAssertTrue(fullAccessOff.blockers.contains("Enable Allow Full Access and verify Foil Keyboard."))

        let badStorage = FoilDictationLoopPresenter.onboardingReadinessPresentation(
            selectedRouteID: "iphone-api-key",
            hasConfiguredAPIKey: true,
            microphoneAllowed: true,
            keyboardHealth: freshEnabledHealth,
            storageReport: FoilKeyboardStorageReport(
                operation: "save",
                phase: .idle,
                hasTranscript: false,
                canonicalPath: nil,
                canonicalWriteSucceeded: false,
                canonicalWriteError: "Missing app group container",
                canonicalVerificationPhase: nil,
                canonicalVerificationHasTranscript: nil,
                defaultsWriteAttempted: true,
                fallbackRemovalResults: [],
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            snapshot: .initial,
            now: Date(timeIntervalSince1970: 110)
        )
        XCTAssertFalse(badStorage.isComplete)
        XCTAssertTrue(badStorage.blockers.contains("App Group write or verification failed. Reset shared state, then verify Ready, no transcript."))

        let pendingTranscript = FoilDictationLoopPresenter.onboardingReadinessPresentation(
            selectedRouteID: "iphone-api-key",
            hasConfiguredAPIKey: true,
            microphoneAllowed: true,
            keyboardHealth: freshEnabledHealth,
            storageReport: healthyStorage,
            snapshot: FoilKeyboardSnapshot(
                phase: .complete,
                transcript: "waiting text",
                message: "Ready",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            now: Date(timeIntervalSince1970: 110)
        )
        XCTAssertFalse(pendingTranscript.isComplete)
        XCTAssertTrue(pendingTranscript.blockers.contains("Insert or reset the waiting transcript before calling setup complete."))

        let stuckProcessing = FoilDictationLoopPresenter.onboardingReadinessPresentation(
            selectedRouteID: "iphone-api-key",
            hasConfiguredAPIKey: true,
            microphoneAllowed: true,
            keyboardHealth: freshEnabledHealth,
            storageReport: healthyStorage,
            snapshot: FoilKeyboardSnapshot(
                phase: .processing,
                transcript: nil,
                message: "Transcribing",
                updatedAt: Date(timeIntervalSince1970: 1)
            ),
            now: Date(timeIntervalSince1970: 200)
        )
        XCTAssertFalse(stuckProcessing.isComplete)
        XCTAssertTrue(stuckProcessing.blockers.contains("Retry transcription or reset stuck processing before calling setup complete."))
    }

    func testOnboardingReadinessCompletesOnlyForHealthyIPhoneAPIKeyRoute() {
        let presentation = FoilDictationLoopPresenter.onboardingReadinessPresentation(
            selectedRouteID: "iphone-api-key",
            hasConfiguredAPIKey: true,
            microphoneAllowed: true,
            keyboardHealth: FoilKeyboardHealthReport(
                fullAccessState: .enabled,
                snapshotPhase: .idle,
                snapshotHasTranscript: false,
                message: "Foil Keyboard verified",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            storageReport: FoilKeyboardStorageReport(
                operation: "reset",
                phase: .idle,
                hasTranscript: false,
                canonicalPath: "/tmp/foil-keyboard-snapshot.json",
                canonicalWriteSucceeded: true,
                canonicalWriteError: nil,
                canonicalVerificationPhase: .idle,
                canonicalVerificationHasTranscript: false,
                defaultsWriteAttempted: true,
                fallbackRemovalResults: [],
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            snapshot: .initial,
            now: Date(timeIntervalSince1970: 110)
        )

        XCTAssertTrue(presentation.isComplete)
        XCTAssertEqual(presentation.title, "Ready to dictate and insert")
        XCTAssertTrue(presentation.blockers.isEmpty)
    }

    func testOnboardingReadinessNeverCompletesForStubbedMacRoute() {
        let presentation = FoilDictationLoopPresenter.onboardingReadinessPresentation(
            selectedRouteID: "use-my-mac",
            hasConfiguredAPIKey: true,
            microphoneAllowed: true,
            keyboardHealth: FoilKeyboardHealthReport(
                fullAccessState: .enabled,
                snapshotPhase: .idle,
                snapshotHasTranscript: false,
                message: "Foil Keyboard verified",
                updatedAt: Date(timeIntervalSince1970: 100)
            ),
            storageReport: .initial,
            snapshot: .initial,
            now: Date(timeIntervalSince1970: 110)
        )

        XCTAssertFalse(presentation.isComplete)
        XCTAssertTrue(presentation.detail.contains("Mac pairing is not connected in this build"))
    }

    func testBetaGuidanceNamesSafeTargetsAndClaimBoundaries() {
        let items = FoilDictationLoopPresenter.betaGuidancePresentation()
        let combined = items.map { "\($0.title) \($0.detail)" }.joined(separator: " ")

        XCTAssertTrue(combined.contains("Tested targets"))
        XCTAssertTrue(combined.contains("Notes"))
        XCTAssertTrue(combined.contains("Safari"))
        XCTAssertTrue(combined.contains("Messages draft"))
        XCTAssertTrue(combined.contains("Do not send"))
        XCTAssertTrue(combined.contains("Mail is deferred"))
        XCTAssertTrue(combined.contains("Secure fields should reject Foil Keyboard"))
        XCTAssertTrue(combined.contains("not broad iPhone app support"))
    }
}
