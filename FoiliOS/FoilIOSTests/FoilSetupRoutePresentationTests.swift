import XCTest
@testable import FoilIOS

final class FoilSetupRoutePresentationTests: XCTestCase {
    func testRouteChoicesKeepMacFutureFacingButDefaultToCurrentBetaPath() {
        let routes = FoilDictationLoopPresenter.routeChoicePresentation()

        XCTAssertEqual(FoilDictationLoopPresenter.defaultBetaRouteID, "iphone-api-key")
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
        XCTAssertTrue(routes[0].detail.contains("future product path"))
        XCTAssertTrue(routes[0].detail.contains("not the current beta setup route"))
        XCTAssertFalse(routes[0].detail.contains("Mac actually handled"))
        XCTAssertEqual(routes[1].routeID, "iphone-api-key")
        XCTAssertFalse(routes[1].isRecommended)
        XCTAssertTrue(routes[1].isUsableNow)
        XCTAssertEqual(routes[1].badge, "Current beta path")
        XCTAssertTrue(routes[1].detail.contains("fully usable for this beta"))
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
        XCTAssertTrue(combined.contains("iOS shows a broad keyboard warning"))
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
}
