import Foundation

extension FoilDictationLoopPresenter {
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

    static func appPresentation(
        snapshot: FoilKeyboardSnapshot,
        isRecording: Bool,
        hasSavedRecording: Bool,
        isTranscribing: Bool,
        recoveryMessage: String?,
        providerRecoveryRequiresKeyUpdate: Bool = false,
        now: Date = Date()
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
                detail: "Return to your target field, switch to Foil Keyboard, then tap Insert latest once. Tested targets: Safari, blank Notes, or a Messages draft.",
                systemImage: "keyboard.badge.ellipsis",
                tone: .success,
                primaryAction: nil
            )
        }

        if snapshot.phase == .processing || isTranscribing {
            if snapshot.phase == .processing,
               !isTranscribing,
               now.timeIntervalSince(snapshot.updatedAt) > processingRecoveryAfter {
                return FoilAppLoopPresentation(
                    title: "Processing may be stuck",
                    badge: "Recover",
                    detail: "This transcript has been processing longer than expected. Retry transcription if the recording is saved, or reset shared state before recording again.",
                    systemImage: "exclamationmark.arrow.triangle.2.circlepath",
                    tone: .attention,
                    primaryAction: hasSavedRecording ? .retryTranscript : .reset
                )
            }

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
            if providerRecoveryRequiresKeyUpdate {
                return FoilAppLoopPresentation(
                    title: "Update provider key",
                    badge: "Provider",
                    detail: recoveryMessage ?? "Update the saved provider key, then transcribe again.",
                    systemImage: "key.fill",
                    tone: .attention,
                    primaryAction: nil
                )
            }

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
            detail: "Record here. When the transcript is ready, return to the target field, switch to Foil Keyboard, and insert once.",
            systemImage: "mic.circle.fill",
            tone: .ready,
            primaryAction: .record
        )
    }

    static func shouldPrioritizeSetup(
        onboardingReadiness: FoilOnboardingReadinessPresentation,
        snapshot: FoilKeyboardSnapshot,
        isRecording: Bool,
        hasSavedRecording: Bool,
        isTranscribing: Bool
    ) -> Bool {
        guard !onboardingReadiness.isComplete else { return false }
        guard !isRecording, !hasSavedRecording, !isTranscribing else { return false }
        guard snapshot.phase == .idle else { return false }
        let transcript = snapshot.transcript?.trimmingCharacters(in: .whitespacesAndNewlines)
        return transcript?.isEmpty != false
    }
}
