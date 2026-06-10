# T003 Worker: Mac Pairing Stub UX

## Summary

Implemented the approved presenter-level Mac pairing preview seam. The Mac path
now names the future local bridge contract deterministically while still saying
pairing is not connected in this build and routing users back to the usable
iPhone API-key setup path.

## Product Changes

- Added `FoilMacPairingPreviewPresentation` to carry the shared-contract
  identifiers from `usefoil/foil#298`.
- Added presenter constants for `foil.localBridge`, `mac-selected`,
  `RouteReceipt`, and the supported future Mac route IDs.
- Updated the Mac route details screen to render the presenter model instead of
  hard-coded copy.
- Kept the fallback action pointed at `iphone-api-key`.

## Tests

Added
`testMacPairingPreviewExposesSharedContractNamesWithoutClaimingBridgeReady`.
The test proves the preview exposes:

- `foil.localBridge`;
- `mac-selected`;
- `RouteReceipt`;
- `local-whisper-cpp`;
- `openai-whisper`;
- `custom-openai-compatible`;
- copy that says the Mac path is not connected in this build;
- fallback copy that keeps API-key setup reachable.

Existing focused tests still prove:

- the Mac route is first and recommended while the API-key route is usable;
- the stubbed Mac route cannot complete onboarding;
- the API-key route completes only when provider, microphone, Full Access,
  keyboard health, App Group state, and insertion readiness are healthy;
- diagnostics/fake transcript tools remain under Advanced / Support;
- stale/non-complete transcript states do not advertise unsafe insertion.

## Evidence

- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,id=8A7EA28F-4690-4816-B650-38648E6F44FB' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests CODE_SIGNING_ALLOWED=NO`
  passed 21 tests with 0 failures on iPhone 17 simulator / iOS 26.5.
- The first verification attempt using destination `name=iPhone 16` failed
  because that simulator is not installed locally; rerunning against the
  installed iPhone 17 simulator passed.
- A compile failure from the first iPhone 17 run caught a missing explicit
  `return` in `macRouteDetails`; the code was patched and the focused suite
  then passed.

## Privacy

No provider keys, App Store Connect keys, JWTs, raw WDA trees, screenshots,
private phone content, archives, or IPA artifacts were created or printed.
