import Foundation

enum FoilDictationLoopPresenter {
    static let processingRecoveryAfter: TimeInterval = 90
    static let macRouteID = "use-my-mac"
    static let iPhoneAPIKeyRouteID = "iphone-api-key"
    static let advancedRouteID = "advanced"
    static let defaultBetaRouteID = iPhoneAPIKeyRouteID
    static let localBridgeProtocolFamily = "foil.localBridge"
    static let macSelectedRouteID = "mac-selected"
    static let routeReceiptName = "RouteReceipt"
    static let macSupportedRouteIDs = [
        "local-whisper-cpp",
        "openai-whisper",
        "custom-openai-compatible"
    ]

}
