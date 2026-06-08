# T003 Worker

## Result

Implemented the approved onboarding polish slice:

- added presenter-owned setup checklist items for provider key, microphone,
  keyboard install, Full Access, recording, return/insert, and reset;
- added presenter-owned beta guidance for safe targets and caveats;
- rendered a new "Closed beta setup" panel and "Where to test" panel in
  `ContentView`;
- preserved existing keyboard insertion, shared-state, provider, microphone,
  and recovery behavior.

## TDD Receipt

Red:

- `xcodebuild test -project FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests`
- Expected failure: `FoilDictationLoopPresenter` had no
  `setupChecklistPresentation` or `betaGuidancePresentation`.

Green:

- Focused presentation tests passed: 15 tests, 0 failures.
- Full `FoilIOSTests` passed: 23 tests, 0 failures.
- Simulator build passed: `** BUILD SUCCEEDED **`.

## UI Proof

- Top setup screenshot:
  `notes/receipts/onboarding-setup-top-sim.jpg`.
- Scrolled guidance screenshot:
  `notes/receipts/onboarding-guidance-sim.jpg`.
- Runtime snapshots confirmed visible text for `Closed beta setup`,
  `Provider key`, `Add Foil Keyboard`, `Allow Full Access`, `Return and insert`,
  `Reset when stale`, `Where to test`, `Messages draft only`, `Mail is
  deferred`, and secure-field rejection copy.

## Files Changed

- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`
- `FoiliOS/FoilIOSApp/ContentView.swift`
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`
- `docs/goals/ios-v0.32-ios-app-onboarding-polish/**`
