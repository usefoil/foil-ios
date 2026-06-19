# T003 First Slice Decision

Date: 2026-06-19
Result: `approved`

## Decision

Approve a bounded Worker slice: make setup lead the Foil app when setup is not
ready and no dictation/transcript flow is active.

## Rationale

The T001 source map found a first-run UX risk: the dictation console always
appears before route/setup readiness, so a tester can see `Record in Foil`
before seeing that provider key, microphone, keyboard health, Full Access, App
Group state, or route choice are not ready. T002 could not physically verify the
flow because iPhone-preview is unavailable and WDA is unreachable, but the
source and tests are strong enough to improve the ordering conservatively.

This slice should not remove existing recording controls, change keyboard
insertion, touch provider storage, or expand host-app claims. Once a recording,
transcription, transcript, saved recording, or setup-ready state exists, the
dictation console should remain the lead surface.

## Worker Scope

Objective: Add a tested presentation/layout decision that prioritizes route and
setup readiness before the dictation console only for idle, not-ready setup
states. Use it in `ContentView`.

Allowed files:

- `FoiliOS/FoilIOSApp/ContentView.swift`
- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`
- `docs/goals/ios-ux-polish-safe-paths/**`

Verification:

- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests`
- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilKeyboardBridgeTests`
- `git diff --check`
- GoalBuddy checker for this board.
- Privacy/no-overclaim scan over changed files.

Stop if the change:

- changes insertion, App Group consume/reset semantics, provider key storage, or
  keyboard extension behavior;
- implies Mac bridge support, arbitrary app support, Mail support, Messages
  delivery, secure-field insertion, or private-thread support;
- hides active recording/transcription/transcript recovery behind setup;
- requires physical host-app receipts while preflight remains unsafe.
