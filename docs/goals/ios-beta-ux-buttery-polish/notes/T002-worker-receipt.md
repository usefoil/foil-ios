# T002 Worker Receipt - Keyboard State Clarity

## Result

Done.

## Changes

- Made disabled keyboard insert states explain why insertion is unavailable:
  - Full Access off now labels the primary blocked action as "Enable Full Access".
  - Idle says "No transcript to insert" instead of a vague no-transcript state.
  - Recording/listening states say "Finish in Foil".
  - Processing says "Waiting for transcript".
  - Failed says "No insertable transcript".
- Made stale complete transcripts clearly different from empty states:
  - Stale copy says the transcript is stale.
  - Clear action says "Clear stale transcript".
  - Guidance asks the tester to clear and record again in Foil.
- Made successful insertion reinforce exact-once behavior:
  - Complete keyboard state says "Tap Insert latest once, then switch keyboards to keep typing."
  - Post-insert keyboard message says "Inserted once. Switch keyboards to keep typing."
- Added focused presentation tests for complete and non-insertable keyboard states.

## Verification

- PASS: `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests`
  - Executed 33 tests, 0 failures.
- PASS: `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilKeyboardBridgeTests`
  - Executed 7 tests, 0 failures.
- PASS: `git diff --check`.
- PASS: GoalBuddy state checker before receipt update.
- PASS: privacy/no-overclaim scan over changed files.
  - Hits were limited to intended guardrail text in the goal/state docs.

## Notes

- A parallel presentation-test run exited before establishing the test connection while another Xcode test run was using the same simulator. The presentation suite passed on a solo rerun, so this was treated as simulator runner contention rather than a product or assertion failure.
- The bridge behavior was not weakened: focused bridge tests still prove consume-once insertion, complete/non-empty requirements, stale rejection, and non-complete leftover rejection.

## Files

- `FoiliOS/FoilKeyboard/KeyboardViewController.swift`
- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`
- `docs/goals/ios-beta-ux-buttery-polish/state.yaml`
- `docs/goals/ios-beta-ux-buttery-polish/notes/T002-worker-receipt.md`
