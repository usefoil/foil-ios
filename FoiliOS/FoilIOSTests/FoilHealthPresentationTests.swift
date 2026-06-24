import XCTest
@testable import FoilIOS

final class FoilHealthPresentationTests: XCTestCase {
    func testStorageHealthPresentationNamesAppGroupRecovery() {
        let failedStorage = FoilKeyboardStorageReport(
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
        )

        let failedPresentation = FoilDictationLoopPresenter.storageHealthPresentation(
            snapshot: .initial,
            storageReport: failedStorage
        )

        XCTAssertEqual(failedPresentation.detail, "App Group write failed. Reset shared state, then verify Ready, no transcript.")
        XCTAssertTrue(failedPresentation.recoveryMessage?.contains("App Group storage failed") == true)

        let healthyPresentation = FoilDictationLoopPresenter.storageHealthPresentation(
            snapshot: .initial,
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
            )
        )

        XCTAssertEqual(healthyPresentation.detail, "Ready, no transcript")
        XCTAssertNil(healthyPresentation.recoveryMessage)
    }

    func testKeyboardFullAccessOffTellsUserToEnableAndCycleBack() {
        let presentation = FoilDictationLoopPresenter.keyboardPresentation(
            snapshot: .initial,
            fullAccessEnabled: false
        )

        XCTAssertEqual(presentation.status, "Open Foil")
        XCTAssertEqual(presentation.insertTitle, "Enable Full Access")
        XCTAssertEqual(presentation.clearTitle, "Full Access off")
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
