import Foundation

enum FoilLoopTone: Equatable {
    case ready
    case live
    case working
    case success
    case attention
}

enum FoilAppPrimaryAction: Equatable {
    case record
    case stopRecording
    case createTranscript
    case retryTranscript
    case reset

    var title: String {
        switch self {
        case .record:
            "Record in Foil"
        case .stopRecording:
            "Finish recording"
        case .createTranscript:
            "Create transcript"
        case .retryTranscript:
            "Retry transcript"
        case .reset:
            "Reset dictation"
        }
    }

    var systemImage: String {
        switch self {
        case .record:
            "record.circle"
        case .stopRecording:
            "stop.circle"
        case .createTranscript:
            "text.bubble"
        case .retryTranscript:
            "arrow.clockwise"
        case .reset:
            "arrow.counterclockwise"
        }
    }

    var accessibilityIdentifier: String {
        switch self {
        case .record:
            "primary-record-dictation-button"
        case .stopRecording:
            "primary-finish-recording-button"
        case .createTranscript:
            "primary-create-transcript-button"
        case .retryTranscript:
            "primary-retry-transcript-button"
        case .reset:
            "primary-reset-dictation-button"
        }
    }
}

enum FoilAppSecondaryAction: Equatable {
    case cancelRecording

    var title: String {
        switch self {
        case .cancelRecording:
            "Cancel recording"
        }
    }

    var systemImage: String {
        switch self {
        case .cancelRecording:
            "xmark.circle"
        }
    }

    var accessibilityIdentifier: String {
        switch self {
        case .cancelRecording:
            "secondary-cancel-recording-button"
        }
    }
}

struct FoilAppLoopPresentation: Equatable {
    var title: String
    var badge: String
    var detail: String
    var systemImage: String
    var tone: FoilLoopTone
    var primaryAction: FoilAppPrimaryAction?
    var secondaryAction: FoilAppSecondaryAction?
}

struct FoilKeyboardLoopPresentation: Equatable {
    var status: String
    var message: String
    var insertTitle: String
    var clearTitle: String
    var startTitle: String
}

struct FoilKeyboardHealthPresentation: Equatable {
    var detail: String
    var recoveryMessage: String?
    var recoverySteps: [String]
}

struct FoilTranscriptReviewPresentation: Equatable {
    var transcript: String
    var guidance: String
    var retryTitle: String
    var resetTitle: String
    var canRetryRecording: Bool
}

struct FoilSetupChecklistItem: Equatable, Identifiable {
    var title: String
    var detail: String
    var systemImage: String

    var id: String { title }
}

struct FoilSetupRoutePresentation: Equatable, Identifiable {
    var routeID: String
    var title: String
    var badge: String
    var detail: String
    var systemImage: String
    var isRecommended: Bool
    var isUsableNow: Bool

    var id: String { routeID }
}

struct FoilMacPairingPreviewPresentation: Equatable {
    var protocolFamily: String
    var requestedRouteID: String
    var receiptName: String
    var supportedRouteIDs: [String]
    var title: String
    var detail: String
    var contractDetail: String
    var receiptDetail: String
    var fallbackTitle: String
}

struct FoilOnboardingReadinessPresentation: Equatable {
    var title: String
    var detail: String
    var systemImage: String
    var isComplete: Bool
    var blockers: [String]
}

struct FoilBetaGuidanceItem: Equatable, Identifiable {
    var title: String
    var detail: String
    var systemImage: String

    var id: String { title }
}

enum FoilMicrophoneSetupState: Equatable {
    case allowed
    case blocked
    case needsPrompt
    case unavailable
}

struct FoilSetupReadinessPresentation: Equatable {
    var title: String
    var detail: String
    var nextAction: String
    var systemImage: String
    var tone: FoilLoopTone
}

enum FoilDictationLoopPresenter {
    static let macRouteID = "use-my-mac"
    static let iPhoneAPIKeyRouteID = "iphone-api-key"
    static let advancedRouteID = "advanced"
    static let localBridgeProtocolFamily = "foil.localBridge"
    static let macSelectedRouteID = "mac-selected"
    static let routeReceiptName = "RouteReceipt"
    static let macSupportedRouteIDs = [
        "local-whisper-cpp",
        "openai-whisper",
        "custom-openai-compatible"
    ]

    static func setupReadinessPresentation(
        hasProviderKey: Bool,
        microphoneState: FoilMicrophoneSetupState,
        keyboardHealth: FoilKeyboardHealthReport,
        snapshot: FoilKeyboardSnapshot,
        now: Date = Date()
    ) -> FoilSetupReadinessPresentation {
        if !hasProviderKey {
            return FoilSetupReadinessPresentation(
                title: "Setup not started",
                detail: "Save your Groq provider key before recording.",
                nextAction: "Paste the key below, then tap Save key.",
                systemImage: "key",
                tone: .attention
            )
        }

        switch microphoneState {
        case .blocked:
            return FoilSetupReadinessPresentation(
                title: "Microphone blocked",
                detail: "Foil cannot record until microphone access is enabled in Settings.",
                nextAction: "Open iOS Settings for Foil and allow Microphone.",
                systemImage: "mic.slash",
                tone: .attention
            )
        case .needsPrompt:
            return FoilSetupReadinessPresentation(
                title: "Ready for microphone prompt",
                detail: "Provider is saved. Foil will ask for microphone access when you record.",
                nextAction: "Tap Record in Foil and allow microphone access.",
                systemImage: "mic.badge.plus",
                tone: .ready
            )
        case .unavailable:
            return FoilSetupReadinessPresentation(
                title: "Check microphone",
                detail: "Foil cannot read microphone permission on this device right now.",
                nextAction: "Try recording once, then check iOS Settings if recording fails.",
                systemImage: "mic",
                tone: .attention
            )
        case .allowed:
            break
        }

        let keyboardPresentation = keyboardHealthPresentation(report: keyboardHealth, now: now)
        if keyboardHealth.fullAccessState != .enabled {
            return FoilSetupReadinessPresentation(
                title: keyboardHealth.fullAccessState == .disabled ? "Keyboard blocked" : "Keyboard not verified",
                detail: keyboardPresentation.detail,
                nextAction: keyboardPresentation.recoverySteps.first ?? "Open a safe text field and switch to Foil Keyboard.",
                systemImage: "keyboard.badge.exclamationmark",
                tone: .attention
            )
        }

        if let recoveryMessage = keyboardPresentation.recoveryMessage {
            return FoilSetupReadinessPresentation(
                title: "Refresh keyboard",
                detail: recoveryMessage,
                nextAction: keyboardPresentation.recoverySteps.first ?? "Cycle away from Foil Keyboard, then back.",
                systemImage: "arrow.triangle.2.circlepath",
                tone: .attention
            )
        }

        if snapshot.insertableTranscript != nil {
            return FoilSetupReadinessPresentation(
                title: "Ready to insert",
                detail: "A transcript is waiting for Foil Keyboard.",
                nextAction: "Return to a safe text field and tap Insert latest once.",
                systemImage: "keyboard.badge.ellipsis",
                tone: .success
            )
        }

        if snapshot.phase == .processing {
            return FoilSetupReadinessPresentation(
                title: "Transcript in progress",
                detail: "Foil is preparing text for the keyboard.",
                nextAction: "Wait for the ready state before returning to the target field.",
                systemImage: "text.bubble",
                tone: .working
            )
        }

        if snapshot.phase == .failed {
            return FoilSetupReadinessPresentation(
                title: "Recovery needed",
                detail: snapshot.message,
                nextAction: "Record again or reset shared state before inserting.",
                systemImage: "exclamationmark.circle",
                tone: .attention
            )
        }

        return FoilSetupReadinessPresentation(
            title: "Setup ready",
            detail: "Provider, microphone, and Foil Keyboard are ready for the narrow closed beta loop.",
            nextAction: "Record in Foil, then return to a safe text field and insert once.",
            systemImage: "checkmark.circle",
            tone: .success
        )
    }

    static func routeChoicePresentation() -> [FoilSetupRoutePresentation] {
        [
            FoilSetupRoutePresentation(
                routeID: macRouteID,
                title: "Use my Mac",
                badge: "Recommended next",
                detail: "Mac pairing is coming soon. After pairing is available, this route can send iPhone audio to your paired Mac, use the Mac's selected route, and show a RouteReceipt only after the Mac handles the request.",
                systemImage: "desktopcomputer",
                isRecommended: true,
                isUsableNow: false
            ),
            FoilSetupRoutePresentation(
                routeID: iPhoneAPIKeyRouteID,
                title: "Use an API key on this iPhone",
                badge: "Works now",
                detail: "This path is fully usable today: save a provider key here, record on this iPhone, then insert the transcript from Foil Keyboard.",
                systemImage: "iphone.gen3",
                isRecommended: false,
                isUsableNow: true
            ),
            FoilSetupRoutePresentation(
                routeID: advancedRouteID,
                title: "Advanced, demo, and support",
                badge: "Support",
                detail: "Diagnostics, fake transcript tools, secure-field checks, and narrow beta target notes live here.",
                systemImage: "wrench.and.screwdriver",
                isRecommended: false,
                isUsableNow: true
            )
        ]
    }

    static func macPairingPreviewPresentation() -> FoilMacPairingPreviewPresentation {
        FoilMacPairingPreviewPresentation(
            protocolFamily: localBridgeProtocolFamily,
            requestedRouteID: macSelectedRouteID,
            receiptName: routeReceiptName,
            supportedRouteIDs: macSupportedRouteIDs,
            title: "Mac pairing preview",
            detail: "Mac pairing is not connected in this build. Foil will not call setup complete from this route until pairing, route receipt, keyboard health, and insertion are all proven.",
            contractDetail: "Future bridge requests use \(localBridgeProtocolFamily) and default to \(macSelectedRouteID), so the Mac can resolve its selected transcription route.",
            receiptDetail: "After a Mac handles the request, Foil will show a \(routeReceiptName) with the resolved route, such as \(macSupportedRouteIDs.joined(separator: ", ")).",
            fallbackTitle: "Set up API key on iPhone"
        )
    }

    static func iPhoneAPIKeySetupPresentation() -> [FoilSetupChecklistItem] {
        [
            FoilSetupChecklistItem(
                title: "Save an API key",
                detail: "Add a provider key on this iPhone so Foil can create transcripts without a paired Mac.",
                systemImage: "key"
            ),
            FoilSetupChecklistItem(
                title: "Allow microphone",
                detail: "Foil asks for microphone access when you start recording.",
                systemImage: "mic"
            ),
            FoilSetupChecklistItem(
                title: "Add Foil Keyboard",
                detail: "Settings > General > Keyboard > Keyboards > Add New Keyboard, then choose Foil Keyboard.",
                systemImage: "keyboard"
            ),
            FoilSetupChecklistItem(
                title: "Allow Full Access",
                detail: "Open Foil Keyboard in that list and enable Allow Full Access so it can read and clear Foil's shared transcript state.",
                systemImage: "checkmark.shield"
            ),
            FoilSetupChecklistItem(
                title: "Verify keyboard health",
                detail: "Open a safe text field, switch to Foil Keyboard, then return here and confirm Foil Keyboard checked in.",
                systemImage: "stethoscope"
            ),
            FoilSetupChecklistItem(
                title: "Record and insert once",
                detail: "Record here, create a transcript, then tap Insert latest once in Foil Keyboard.",
                systemImage: "arrow.turn.down.left"
            )
        ]
    }

    static func advancedSupportPresentation() -> [FoilSetupChecklistItem] {
        [
            FoilSetupChecklistItem(
                title: "Diagnostics",
                detail: "Inspect App Group state and keyboard storage without exposing transcript text in receipts.",
                systemImage: "externaldrive"
            ),
            FoilSetupChecklistItem(
                title: "Demo fake transcript",
                detail: "Stage a fake transcript only for support and demo checks.",
                systemImage: "text.badge.checkmark"
            ),
            FoilSetupChecklistItem(
                title: "Secure-field rejection",
                detail: "Use the secure-field test to confirm Foil Keyboard is rejected where iOS blocks custom keyboards.",
                systemImage: "lock"
            ),
            FoilSetupChecklistItem(
                title: "Reset shared state",
                detail: "Clear stale App Group state before starting another setup or insertion check.",
                systemImage: "arrow.counterclockwise"
            )
        ]
    }

    static func setupChecklistPresentation() -> [FoilSetupChecklistItem] {
        iPhoneAPIKeySetupPresentation()
    }

    static func betaGuidancePresentation() -> [FoilBetaGuidanceItem] {
        [
            FoilBetaGuidanceItem(
                title: "Safe targets",
                detail: "Use blank Notes, Safari normal text fields, or a Messages draft with safe test text.",
                systemImage: "checkmark.circle"
            ),
            FoilBetaGuidanceItem(
                title: "Messages draft only",
                detail: "Messages is for draft insertion testing only. Do not send test messages.",
                systemImage: "message"
            ),
            FoilBetaGuidanceItem(
                title: "Deferred targets",
                detail: "Mail is deferred, and Secure fields should reject Foil Keyboard.",
                systemImage: "exclamationmark.triangle"
            ),
            FoilBetaGuidanceItem(
                title: "Narrow beta",
                detail: "This tests the record, return, and insert loop; it is not broad iPhone app support.",
                systemImage: "scope"
            )
        ]
    }

    static func transcriptReviewPresentation(
        snapshot: FoilKeyboardSnapshot,
        hasSavedRecording: Bool
    ) -> FoilTranscriptReviewPresentation? {
        guard let transcript = snapshot.transcript?.trimmingCharacters(in: .whitespacesAndNewlines),
              !transcript.isEmpty else {
            return nil
        }

        return FoilTranscriptReviewPresentation(
            transcript: transcript,
            guidance: "Review before inserting. If this looks wrong, retry the recording or reset and record again.",
            retryTitle: "Retry recording",
            resetTitle: "Reset and record again",
            canRetryRecording: hasSavedRecording
        )
    }

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

    static func onboardingReadinessPresentation(
        selectedRouteID: String,
        hasConfiguredAPIKey: Bool,
        microphoneAllowed: Bool,
        keyboardHealth: FoilKeyboardHealthReport,
        storageReport: FoilKeyboardStorageReport,
        snapshot: FoilKeyboardSnapshot,
        now: Date = Date(),
        staleAfter: TimeInterval = 120
    ) -> FoilOnboardingReadinessPresentation {
        if selectedRouteID == macRouteID {
            return FoilOnboardingReadinessPresentation(
                title: "Mac pairing preview",
                detail: "Mac pairing is not connected in this build. Use the iPhone API-key route for a complete setup today.",
                systemImage: "desktopcomputer.trianglebadge.exclamationmark",
                isComplete: false,
                blockers: ["Use an API key on this iPhone until the Mac bridge is available."]
            )
        }

        if selectedRouteID == advancedRouteID {
            return FoilOnboardingReadinessPresentation(
                title: "Support tools selected",
                detail: "Advanced tools can test and recover the bridge, but they are not a complete first-run route.",
                systemImage: "wrench.and.screwdriver",
                isComplete: false,
                blockers: ["Choose Use my Mac or Use an API key on this iPhone for setup."]
            )
        }

        var blockers: [String] = []
        if !hasConfiguredAPIKey {
            blockers.append("Save an API key on this iPhone.")
        }
        if !microphoneAllowed {
            blockers.append("Allow microphone access before recording.")
        }

        let healthPresentation = keyboardHealthPresentation(
            report: keyboardHealth,
            now: now,
            staleAfter: staleAfter
        )
        if keyboardHealth.fullAccessState != .enabled || healthPresentation.recoveryMessage != nil {
            blockers.append("Enable Allow Full Access and verify Foil Keyboard.")
        }

        if snapshot.insertableTranscript(now: now, staleAfter: staleAfter) != nil {
            blockers.append("Insert or reset the waiting transcript before calling setup complete.")
        } else if snapshot.phase != .idle {
            blockers.append("Reset shared state so setup starts from an idle keyboard bridge.")
        }

        let verifiedCleanSnapshot = storageReport.canonicalVerificationPhase == .idle &&
            storageReport.canonicalVerificationHasTranscript == false
        let bridgeWriteHealthy = storageReport.canonicalWriteSucceeded &&
            storageReport.defaultsWriteAttempted &&
            verifiedCleanSnapshot
        if !bridgeWriteHealthy {
            blockers.append("Reset shared state so the keyboard bridge can write a clean App Group snapshot.")
        }

        if blockers.isEmpty {
            return FoilOnboardingReadinessPresentation(
                title: "Ready to dictate and insert",
                detail: "API key, microphone, Foil Keyboard health, Full Access, and App Group state are ready.",
                systemImage: "checkmark.circle.fill",
                isComplete: true,
                blockers: []
            )
        }

        return FoilOnboardingReadinessPresentation(
            title: "Finish setup",
            detail: "Foil will only call setup complete after the route, microphone, keyboard health, Full Access, and App Group state all check out.",
            systemImage: "exclamationmark.circle.fill",
            isComplete: false,
            blockers: blockers
        )
    }

    static func appPresentation(
        snapshot: FoilKeyboardSnapshot,
        isRecording: Bool,
        hasSavedRecording: Bool,
        isTranscribing: Bool,
        recoveryMessage: String?
    ) -> FoilAppLoopPresentation {
        if isRecording || snapshot.phase == .listening {
            return FoilAppLoopPresentation(
                title: "Recording in Foil",
                badge: "Live",
                detail: "Speak naturally. Finish recording here, then create a transcript for Foil Keyboard.",
                systemImage: "waveform.circle.fill",
                tone: .live,
                primaryAction: .stopRecording,
                secondaryAction: .cancelRecording
            )
        }

        if snapshot.transcript?.isEmpty == false || snapshot.phase == .complete {
            return FoilAppLoopPresentation(
                title: "Ready for keyboard",
                badge: "Return",
                detail: "Return to the text field and tap Insert latest in Foil Keyboard.",
                systemImage: "keyboard.badge.ellipsis",
                tone: .success,
                primaryAction: nil
            )
        }

        if snapshot.phase == .processing || isTranscribing {
            return FoilAppLoopPresentation(
                title: "Creating transcript",
                badge: "Working",
                detail: "Foil is turning the latest recording into text for the keyboard.",
                systemImage: "text.bubble.fill",
                tone: .working,
                primaryAction: nil
            )
        }

        if snapshot.phase == .failed || recoveryMessage != nil {
            return FoilAppLoopPresentation(
                title: "Try again",
                badge: "Recover",
                detail: recoveryMessage ?? snapshot.message,
                systemImage: "exclamationmark.circle.fill",
                tone: .attention,
                primaryAction: hasSavedRecording ? .retryTranscript : .reset
            )
        }

        if hasSavedRecording {
            return FoilAppLoopPresentation(
                title: "Recording saved",
                badge: "Next",
                detail: "Create a transcript, then return to your keyboard to insert it.",
                systemImage: "waveform.badge.checkmark",
                tone: .working,
                primaryAction: .createTranscript
            )
        }

        return FoilAppLoopPresentation(
            title: "Record in Foil",
            badge: "Start",
            detail: "Record here. Return to your keyboard when the transcript is ready.",
            systemImage: "mic.circle.fill",
            tone: .ready,
            primaryAction: .record
        )
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
                insertTitle: "Insert unavailable",
                clearTitle: "Clear unavailable",
                startTitle: "Open Foil"
            )
        }

        let hasTranscript = snapshot.transcript?.isEmpty == false
        let hasInsertableTranscript = snapshot.insertableTranscript(now: now, staleAfter: staleAfter) != nil
        switch snapshot.phase {
        case .complete where hasInsertableTranscript:
            return FoilKeyboardLoopPresentation(
                status: "Transcript ready",
                message: "Tap Insert latest once, then keep typing.",
                insertTitle: "Insert latest",
                clearTitle: "Clear latest",
                startTitle: "Dictate again in Foil"
            )
        case .complete where hasTranscript:
            return FoilKeyboardLoopPresentation(
                status: "Transcript may be stale",
                message: "Clear latest, then dictate again in Foil if this is not the text you expect.",
                insertTitle: "Stale transcript",
                clearTitle: "Clear latest",
                startTitle: "Dictate again in Foil"
            )
        case .failed:
            return FoilKeyboardLoopPresentation(
                status: "Try again in Foil",
                message: "\(snapshot.message) Open Foil to recover or record again.",
                insertTitle: "No transcript yet",
                clearTitle: "Clear",
                startTitle: "Record again in Foil"
            )
        case .handoffRequested, .listening:
            return FoilKeyboardLoopPresentation(
                status: "Recording in Foil",
                message: "Finish recording in Foil, then return here when the transcript is ready.",
                insertTitle: "No transcript yet",
                clearTitle: "Clear",
                startTitle: "Open Foil"
            )
        case .processing:
            return FoilKeyboardLoopPresentation(
                status: "Creating transcript",
                message: "Foil is preparing text. Return here when Insert latest is ready.",
                insertTitle: "No transcript yet",
                clearTitle: "Clear",
                startTitle: "Open Foil"
            )
        case .idle, .complete:
            return FoilKeyboardLoopPresentation(
                status: "Ready to dictate",
                message: "Tap Dictate in Foil to record in the app, then return here.",
                insertTitle: "No transcript yet",
                clearTitle: "Clear",
                startTitle: "Dictate in Foil"
            )
        }
    }
}
