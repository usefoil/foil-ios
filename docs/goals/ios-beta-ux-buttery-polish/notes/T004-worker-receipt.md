# T004 Worker Receipt - Processing And App Group Recovery

## Result

Done.

## Changes

- Added aged-processing recovery presentations:
  - App state changes from passive "Creating transcript" to "Processing may be stuck" after the processing window ages out and transcription is no longer active.
  - Keyboard state says "Processing may be stuck" and explicitly says nothing can be inserted yet.
  - Setup/onboarding readiness blocks completion with retry/reset guidance for stuck processing.
- Added App Group/storage health presentation:
  - Shared state now distinguishes App Group write failure and verification-missing states from normal idle or pending transcript states.
  - Recovery panel can surface the App Group repair message.
  - Onboarding readiness blocker now says App Group write or verification failed and asks for reset plus Ready/no-transcript verification.
- Added bridge proof that reset clears a processing snapshot and reports idle shared state.

## Verification

- PASS: `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests`
  - Executed 37 tests, 0 failures.
- PASS: `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilKeyboardBridgeTests`
  - Executed 8 tests, 0 failures.
- PASS: `git diff --check`.
- PASS: GoalBuddy state checker before receipt update.
- PASS: privacy/no-overclaim scan over changed files.
  - Hits were limited to intended guardrail text in goal/state docs and prior provider no-leak receipt text.

## Notes

- A parallel bridge-test run exited before establishing the test connection while another suite was using the simulator. The bridge suite passed on a solo rerun, so this was treated as simulator runner contention.
- Exact-once and stale rejection were not weakened: the focused bridge suite still covers consume-once insertion, stale complete rejection, non-complete leftover rejection, and reset-to-idle behavior.

## Files

- `FoiliOS/FoilIOSApp/ContentView.swift`
- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`
- `FoiliOS/FoilIOSTests/FoilKeyboardBridgeTests.swift`
- `docs/goals/ios-beta-ux-buttery-polish/state.yaml`
- `docs/goals/ios-beta-ux-buttery-polish/notes/T004-worker-receipt.md`
