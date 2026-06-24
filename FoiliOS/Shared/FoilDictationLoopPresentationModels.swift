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

struct FoilStorageHealthPresentation: Equatable {
    var detail: String
    var recoveryMessage: String?
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
