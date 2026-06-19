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

    func testRouteChoicesPutMacFirstButKeepIPhoneAPIKeyUsable() {
        let routes = FoilDictationLoopPresenter.routeChoicePresentation()

        XCTAssertEqual(
            routes.map(\.title),
            [
                "Use my Mac",
                "Use an API key on this iPhone",
                "Advanced, demo, and support"
            ]
        )
        XCTAssertEqual(routes[0].routeID, "use-my-mac")
        XCTAssertTrue(routes[0].isRecommended)
        XCTAssertFalse(routes[0].isUsableNow)
        XCTAssertTrue(routes[0].detail.contains("pairing is coming soon"))
        XCTAssertTrue(routes[0].detail.contains("After pairing is available"))
        XCTAssertFalse(routes[0].detail.contains("Mac actually handled"))
        XCTAssertEqual(routes[1].routeID, "iphone-api-key")
        XCTAssertFalse(routes[1].isRecommended)
        XCTAssertTrue(routes[1].isUsableNow)
        XCTAssertTrue(routes[1].detail.contains("fully usable today"))
        XCTAssertEqual(routes[2].routeID, "advanced")
    }

    func testMacPairingPreviewExposesSharedContractNamesWithoutClaimingBridgeReady() {
        let preview = FoilDictationLoopPresenter.macPairingPreviewPresentation()

        XCTAssertEqual(preview.protocolFamily, "foil.localBridge")
        XCTAssertEqual(preview.requestedRouteID, "mac-selected")
        XCTAssertEqual(preview.receiptName, "RouteReceipt")
        XCTAssertEqual(
            preview.supportedRouteIDs,
            [
                "local-whisper-cpp",
                "openai-whisper",
                "custom-openai-compatible"
            ]
        )
        XCTAssertTrue(preview.detail.contains("not connected in this build"))
        XCTAssertTrue(preview.detail.contains("will not call setup complete"))
        XCTAssertTrue(preview.contractDetail.contains("foil.localBridge"))
        XCTAssertTrue(preview.contractDetail.contains("mac-selected"))
        XCTAssertTrue(preview.receiptDetail.contains("RouteReceipt"))
        XCTAssertTrue(preview.fallbackTitle.contains("API key"))
    }

    func testIPhoneAPISetupChecklistExplainsFullAccessAndKeyboardVerification() {
        let items = FoilDictationLoopPresenter.iPhoneAPIKeySetupPresentation()
        let combined = items.map { "\($0.title) \($0.detail)" }.joined(separator: " ")

        XCTAssertEqual(
            items.map(\.title),
            [
                "Save an API key",
                "Allow microphone",
                "Add Foil Keyboard",
                "Allow Full Access",
                "Verify keyboard health",
                "Record and insert once"
            ]
        )
        XCTAssertTrue(combined.contains("read and clear Foil's shared transcript state"))
        XCTAssertTrue(combined.contains("Open a safe text field"))
        XCTAssertTrue(combined.contains("Foil Keyboard checked in"))
        XCTAssertTrue(combined.contains("Insert latest once"))
    }

    func testAdvancedSupportItemsHideDiagnosticsAndFakeTranscriptTools() {
        let items = FoilDictationLoopPresenter.advancedSupportPresentation()
        let combined = items.map { "\($0.title) \($0.detail)" }.joined(separator: " ")

        XCTAssertTrue(combined.contains("Diagnostics"))
        XCTAssertTrue(combined.contains("fake transcript"))
        XCTAssertTrue(combined.contains("secure-field"))
        XCTAssertTrue(combined.contains("Reset shared state"))
    }

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
        XCTAssertTrue(badStorage.blockers.contains("Reset shared state so the keyboard bridge can write a clean App Group snapshot."))

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
        XCTAssertTrue(presentation.message.contains("Clear latest"))
        XCTAssertFalse(presentation.message.contains("Insert latest"))
    }

    func testKeyboardFullAccessOffTellsUserToEnableAndCycleBack() {
        let presentation = FoilDictationLoopPresenter.keyboardPresentation(
            snapshot: .initial,
            fullAccessEnabled: false
        )

        XCTAssertEqual(presentation.status, "Open Foil")
        XCTAssertEqual(presentation.insertTitle, "Insert unavailable")
        XCTAssertTrue(presentation.message.contains("Allow Full Access"))
        XCTAssertTrue(presentation.message.contains("refocus the field"))
        XCTAssertTrue(presentation.message.contains("cycle back"))
    }

    func testKeyboardHealthPresentationDetectsUnverifiedState() {
        let presentation = FoilDictationLoopPresenter.keyboardHealthPresentation(
            report: .initial,
            now: Date(timeIntervalSince1970: 500)
        )

        XCTAssertTrue(presentation.detail.contains("Open Foil Keyboard"))
        XCTAssertTrue(presentation.detail.contains("safe text field"))
        XCTAssertEqual(presentation.recoveryMessage, presentation.detail)
        XCTAssertEqual(presentation.recoverySteps.count, 3)
        XCTAssertTrue(presentation.recoverySteps[0].contains("tap inside it"))
        XCTAssertTrue(presentation.recoverySteps[1].contains("globe/Next Keyboard"))
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
        XCTAssertTrue(presentation.detail.contains("refocus the field"))
        XCTAssertEqual(presentation.recoveryMessage, presentation.detail)
        XCTAssertEqual(presentation.recoverySteps.count, 3)
        XCTAssertTrue(presentation.recoverySteps[1].contains("enable Allow Full Access"))
        XCTAssertTrue(presentation.recoverySteps[2].contains("globe/Next Keyboard"))
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
        XCTAssertTrue(presentation.detail.contains("globe/Next Keyboard"))
        XCTAssertEqual(presentation.recoveryMessage, presentation.detail)
        XCTAssertEqual(presentation.recoverySteps.count, 3)
        XCTAssertTrue(presentation.recoverySteps[1].contains("select another keyboard"))
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
