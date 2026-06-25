import AVFoundation
import Foundation

enum FoilContentPresentationSupport {
    static func storageReportSummary(_ storageReport: FoilKeyboardStorageReport) -> String {
        let file = storageReport.canonicalWriteSucceeded ? "file ok" : "file failed"
        let verifiedPhase = storageReport.canonicalVerificationPhase?.displayName ?? "unverified"
        let verifiedTranscript = storageReport.canonicalVerificationHasTranscript == true ? "has transcript" : "no transcript"
        let defaults = storageReport.defaultsWriteAttempted ? "defaults written" : "defaults not written"
        return "Storage \(storageReport.operation): \(file), \(defaults), verified \(verifiedPhase) \(verifiedTranscript)"
    }

    static func recoveryMessage(
        keyboardFullAccessState: FoilKeyboardFullAccessState,
        keyboardHealthPresentation: FoilKeyboardHealthPresentation,
        snapshot: FoilKeyboardSnapshot,
        audioRecoveryMessage: String?,
        transcriptionRecoveryMessage: String?,
        storageHealthPresentation: FoilStorageHealthPresentation
    ) -> String? {
        if keyboardFullAccessState == .disabled,
           let keyboardRecovery = keyboardHealthPresentation.recoveryMessage {
            return keyboardRecovery
        }
        if snapshot.transcript?.isEmpty == false {
            return "Transcript waiting. Insert it once from Foil Keyboard, or reset shared state."
        }
        if let audioRecoveryMessage {
            return audioRecoveryMessage
        }
        if let transcriptionRecoveryMessage {
            return transcriptionRecoveryMessage
        }
        if snapshot.phase == .failed {
            return snapshot.message
        }
        if let storageRecovery = storageHealthPresentation.recoveryMessage {
            return storageRecovery
        }
        if let keyboardRecovery = keyboardHealthPresentation.recoveryMessage {
            return keyboardRecovery
        }
        return nil
    }

    static func handoffGuidance(for phase: FoilKeyboardPhase) -> String? {
        switch phase {
        case .handoffRequested:
            return "Foil is open for dictation."
        case .listening:
            return "Recording is active."
        case .processing:
            return "Transcript creation is underway."
        case .complete:
            return "Transcript is ready for the keyboard."
        case .failed:
            return "Recovery needed before keyboard insertion."
        case .idle:
            return nil
        }
    }

    static var microphonePermissionSummary: String {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            "Microphone allowed"
        case .denied:
            "Microphone blocked in Settings"
        case .undetermined:
            "Microphone will be requested"
        @unknown default:
            "Microphone status unavailable"
        }
    }

    static var microphoneSetupState: FoilMicrophoneSetupState {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            .allowed
        case .denied:
            .blocked
        case .undetermined:
            .needsPrompt
        @unknown default:
            .unavailable
        }
    }
}
