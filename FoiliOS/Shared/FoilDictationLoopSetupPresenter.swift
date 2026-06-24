import Foundation

extension FoilDictationLoopPresenter {
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
                detail: "Save your Groq provider key on this iPhone before recording. A saved key is verified only after a successful transcription.",
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
                detail: "Provider key is saved on this iPhone. Foil will verify it when transcription succeeds.",
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

        if snapshot.insertableTranscript(now: now) != nil {
            return FoilSetupReadinessPresentation(
                title: "Ready to insert",
                detail: "A transcript is waiting for Foil Keyboard.",
                nextAction: "Return to a safe text field and tap Insert latest once.",
                systemImage: "keyboard.badge.ellipsis",
                tone: .success
            )
        }

        if snapshot.phase == .processing {
            if now.timeIntervalSince(snapshot.updatedAt) > processingRecoveryAfter {
                return FoilSetupReadinessPresentation(
                    title: "Transcript stuck",
                    detail: "Foil has been processing longer than expected. Nothing is insertable yet.",
                    nextAction: "Retry transcription if the recording is saved, or reset shared state before starting again.",
                    systemImage: "exclamationmark.arrow.triangle.2.circlepath",
                    tone: .attention
                )
            }

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
            detail: "Saved provider key, microphone, and Foil Keyboard are ready for the narrow closed beta loop. Provider verification still depends on a successful transcription.",
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
                badge: "Future path",
                detail: "Mac pairing is coming soon. This is the future product path, but it is not the current beta setup route. After pairing is available, Foil will show a RouteReceipt only after the Mac handles the request.",
                systemImage: "desktopcomputer",
                isRecommended: true,
                isUsableNow: false
            ),
            FoilSetupRoutePresentation(
                routeID: iPhoneAPIKeyRouteID,
                title: "Use an API key on this iPhone",
                badge: "Current beta path",
                detail: "This path is fully usable for this beta: save a provider key here, record on this iPhone, then insert the transcript from Foil Keyboard.",
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
                detail: "Open Foil Keyboard in that list and enable Allow Full Access. iOS shows a broad keyboard warning; Foil uses Full Access only to read and clear Foil's shared transcript state.",
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
                title: "Tested targets",
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
        } else if snapshot.phase == .processing,
                  now.timeIntervalSince(snapshot.updatedAt) > processingRecoveryAfter {
            blockers.append("Retry transcription or reset stuck processing before calling setup complete.")
        } else if snapshot.phase != .idle {
            blockers.append("Reset shared state so setup starts from an idle keyboard bridge.")
        }

        let verifiedCleanSnapshot = storageReport.canonicalVerificationPhase == .idle &&
            storageReport.canonicalVerificationHasTranscript == false
        let bridgeWriteHealthy = storageReport.canonicalWriteSucceeded &&
            storageReport.defaultsWriteAttempted &&
            verifiedCleanSnapshot
        if !bridgeWriteHealthy {
            blockers.append("App Group write or verification failed. Reset shared state, then verify Ready, no transcript.")
        }

        if blockers.isEmpty {
            return FoilOnboardingReadinessPresentation(
                title: "Ready to dictate and insert",
                detail: "Saved API key, microphone, Foil Keyboard health, Full Access, and App Group state are ready. Provider verification still depends on a successful transcription.",
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
}
