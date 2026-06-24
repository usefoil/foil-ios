import Foundation

extension FoilDictationLoopPresenter {
    static func keyboardHealthPresentation(
        report: FoilKeyboardHealthReport,
        now: Date = Date(),
        staleAfter: TimeInterval = 120
    ) -> FoilKeyboardHealthPresentation {
        switch report.fullAccessState {
        case .disabled:
            let message = "Allow Full Access is off. Enable it in Keyboard settings, then refocus the field and cycle back to Foil Keyboard."
            return FoilKeyboardHealthPresentation(
                detail: message,
                recoveryMessage: message,
                recoverySteps: [
                    "Open Settings > General > Keyboard > Keyboards.",
                    "Select Foil Keyboard and enable Allow Full Access.",
                    "Return to the target field, tap it again, then use globe/Next Keyboard to select Foil Keyboard."
                ]
            )
        case .unverified:
            let message = "Open Foil Keyboard in a safe text field to verify Full Access."
            return FoilKeyboardHealthPresentation(
                detail: message,
                recoveryMessage: message,
                recoverySteps: [
                    "Open a safe text field and tap inside it.",
                    "Use globe/Next Keyboard to select Foil Keyboard.",
                    "Return to Foil and check Keyboard health again."
                ]
            )
        case .enabled:
            if now.timeIntervalSince(report.updatedAt) > staleAfter {
                let message = "Foil Keyboard has not checked in recently. Tap the target field again, then use globe/Next Keyboard to cycle back."
                return FoilKeyboardHealthPresentation(
                    detail: message,
                    recoveryMessage: message,
                    recoverySteps: [
                        "Tap the target text field again.",
                        "Use globe/Next Keyboard to select another keyboard, then Foil Keyboard.",
                        "Return here if Insert latest still looks stale."
                    ]
                )
            }

            let detail = report.snapshotHasTranscript
                ? "Full Access on, transcript waiting in keyboard."
                : "Full Access on, ready for dictation."
            return FoilKeyboardHealthPresentation(detail: detail, recoveryMessage: nil, recoverySteps: [])
        }
    }

    static func storageHealthPresentation(
        snapshot: FoilKeyboardSnapshot,
        storageReport: FoilKeyboardStorageReport
    ) -> FoilStorageHealthPresentation {
        if snapshot.transcript?.isEmpty == false {
            return FoilStorageHealthPresentation(detail: "Transcript pending", recoveryMessage: nil)
        }

        if storageReport.operation != "none", !storageReport.canonicalWriteSucceeded {
            let error = storageReport.canonicalWriteError ?? "App Group write did not complete."
            return FoilStorageHealthPresentation(
                detail: "App Group write failed. Reset shared state, then verify Ready, no transcript.",
                recoveryMessage: "App Group storage failed: \(error). Reset shared state, then verify the Shared state row returns to Ready, no transcript."
            )
        }

        if storageReport.operation != "none",
           storageReport.canonicalVerificationPhase == nil ||
            storageReport.canonicalVerificationHasTranscript == nil {
            return FoilStorageHealthPresentation(
                detail: "App Group verification missing. Reset shared state, then verify again.",
                recoveryMessage: "Foil could not verify the App Group snapshot after writing it. Reset shared state before trying another insertion."
            )
        }

        if snapshot.phase == .idle {
            return FoilStorageHealthPresentation(detail: "Ready, no transcript", recoveryMessage: nil)
        }

        return FoilStorageHealthPresentation(detail: snapshot.phase.displayName, recoveryMessage: nil)
    }

    static func keyboardPresentation(
        snapshot: FoilKeyboardSnapshot,
        fullAccessEnabled: Bool,
        now: Date = Date(),
        staleAfter: TimeInterval = FoilKeyboardSnapshot.defaultTranscriptStaleAfter
    ) -> FoilKeyboardLoopPresentation {
        guard fullAccessEnabled else {
            return FoilKeyboardLoopPresentation(
                status: "Open Foil",
                message: "Allow Full Access in Settings, then refocus the field and cycle back to Foil Keyboard.",
                insertTitle: "Enable Full Access",
                clearTitle: "Full Access off",
                startTitle: "Open Foil"
            )
        }

        let hasTranscript = snapshot.transcript?.isEmpty == false
        let hasInsertableTranscript = snapshot.insertableTranscript(now: now, staleAfter: staleAfter) != nil
        switch snapshot.phase {
        case .complete where hasInsertableTranscript:
            return FoilKeyboardLoopPresentation(
                status: "Transcript ready",
                message: "Tap Insert latest once, then switch keyboards to keep typing.",
                insertTitle: "Insert latest",
                clearTitle: "Clear latest",
                startTitle: "Dictate again in Foil"
            )
        case .complete where hasTranscript:
            return FoilKeyboardLoopPresentation(
                status: "Transcript may be stale",
                message: "This transcript is stale. Clear stale transcript, then record again in Foil.",
                insertTitle: "Stale transcript",
                clearTitle: "Clear stale transcript",
                startTitle: "Dictate again in Foil"
            )
        case .failed:
            return FoilKeyboardLoopPresentation(
                status: "Try again in Foil",
                message: "\(snapshot.message) Open Foil to recover or record again.",
                insertTitle: "No insertable transcript",
                clearTitle: "Clear",
                startTitle: "Record again in Foil"
            )
        case .handoffRequested, .listening:
            return FoilKeyboardLoopPresentation(
                status: "Recording in Foil",
                message: "Finish recording in Foil, then return here when the transcript is ready.",
                insertTitle: "Finish in Foil",
                clearTitle: "Clear",
                startTitle: "Open Foil"
            )
        case .processing:
            if now.timeIntervalSince(snapshot.updatedAt) > processingRecoveryAfter {
                return FoilKeyboardLoopPresentation(
                    status: "Processing may be stuck",
                    message: "Open Foil to retry transcription or reset shared state. Nothing can be inserted yet.",
                    insertTitle: "Waiting for transcript",
                    clearTitle: "Clear stuck processing",
                    startTitle: "Open Foil"
                )
            }

            return FoilKeyboardLoopPresentation(
                status: "Creating transcript",
                message: "Foil is preparing text. Return here when Insert latest is ready.",
                insertTitle: "Waiting for transcript",
                clearTitle: "Clear",
                startTitle: "Open Foil"
            )
        case .idle, .complete:
            return FoilKeyboardLoopPresentation(
                status: "Ready to dictate",
                message: "Tap Dictate in Foil to record in the app, then return here.",
                insertTitle: "No transcript to insert",
                clearTitle: "Clear",
                startTitle: "Dictate in Foil"
            )
        }
    }
}
