import Foundation

enum FoilKeyboardPhase: String, Codable, Equatable {
    case idle
    case handoffRequested
    case listening
    case processing
    case complete
    case failed

    var displayName: String {
        switch self {
        case .idle:
            "Ready"
        case .handoffRequested:
            "Opening Foil"
        case .listening:
            "Listening"
        case .processing:
            "Processing"
        case .complete:
            "Transcript Ready"
        case .failed:
            "Needs Attention"
        }
    }
}

struct FoilKeyboardSnapshot: Codable, Equatable {
    static let defaultTranscriptStaleAfter: TimeInterval = 300

    var phase: FoilKeyboardPhase
    var transcript: String?
    var message: String
    var updatedAt: Date

    func insertableTranscript(
        now: Date = Date(),
        staleAfter: TimeInterval = FoilKeyboardSnapshot.defaultTranscriptStaleAfter
    ) -> String? {
        guard phase == .complete else { return nil }
        guard now.timeIntervalSince(updatedAt) <= staleAfter else { return nil }
        let trimmedTranscript = transcript?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let trimmedTranscript, !trimmedTranscript.isEmpty else { return nil }
        return trimmedTranscript
    }

    static var initial: FoilKeyboardSnapshot {
        FoilKeyboardSnapshot(
            phase: .idle,
            transcript: nil,
            message: "Ready",
            updatedAt: Date()
        )
    }
}

struct FoilKeyboardStoragePathResult: Codable, Equatable {
    var path: String
    var succeeded: Bool
    var error: String?
}

struct FoilKeyboardStorageReport: Codable, Equatable {
    var operation: String
    var phase: FoilKeyboardPhase
    var hasTranscript: Bool
    var consumedPhase: FoilKeyboardPhase? = nil
    var consumedHadInsertableTranscript: Bool? = nil
    var insertedCharacterCount: Int? = nil
    var canonicalPath: String?
    var canonicalWriteSucceeded: Bool
    var canonicalWriteError: String?
    var canonicalVerificationPhase: FoilKeyboardPhase?
    var canonicalVerificationHasTranscript: Bool?
    var defaultsWriteAttempted: Bool
    var fallbackRemovalResults: [FoilKeyboardStoragePathResult]
    var updatedAt: Date

    static var initial: FoilKeyboardStorageReport {
        FoilKeyboardStorageReport(
            operation: "none",
            phase: .idle,
            hasTranscript: false,
            consumedPhase: nil,
            consumedHadInsertableTranscript: nil,
            insertedCharacterCount: nil,
            canonicalPath: nil,
            canonicalWriteSucceeded: false,
            canonicalWriteError: nil,
            canonicalVerificationPhase: nil,
            canonicalVerificationHasTranscript: nil,
            defaultsWriteAttempted: false,
            fallbackRemovalResults: [],
            updatedAt: Date()
        )
    }
}

enum FoilKeyboardFullAccessState: String, Codable, Equatable {
    case unverified
    case disabled
    case enabled

    var displayName: String {
        switch self {
        case .unverified:
            "Not verified"
        case .disabled:
            "Full Access off"
        case .enabled:
            "Full Access on"
        }
    }
}

struct FoilKeyboardHealthReport: Codable, Equatable {
    var fullAccessState: FoilKeyboardFullAccessState
    var snapshotPhase: FoilKeyboardPhase
    var snapshotHasTranscript: Bool
    var message: String
    var updatedAt: Date

    static var initial: FoilKeyboardHealthReport {
        FoilKeyboardHealthReport(
            fullAccessState: .unverified,
            snapshotPhase: .idle,
            snapshotHasTranscript: false,
            message: "Open Foil Keyboard to verify setup",
            updatedAt: .distantPast
        )
    }
}

enum FoilIOSCommandAction: String, Codable, Equatable {
    case startRecording
    case stopRecording
    case transcribeLatest
    case resetSharedState
    case completeFakeTranscript
}

struct FoilIOSCommand: Codable, Equatable {
    var id: String
    var action: FoilIOSCommandAction
    var updatedAt: Date
}
