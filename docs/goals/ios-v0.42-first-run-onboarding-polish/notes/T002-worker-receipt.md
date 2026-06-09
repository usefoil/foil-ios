# T002 Worker Receipt

## Claim

The v0.42 onboarding polish adds a state-specific setup readiness summary that
helps testers understand first-run, partial setup, blocked keyboard, stale
keyboard, ready-to-insert, and setup-complete states without broadening beta
claims.

## Changes

- Added `FoilSetupReadinessPresentation` and `FoilMicrophoneSetupState` in
  `FoiliOS/Shared/FoilDictationLoopPresenter.swift`.
- Rendered the readiness summary at the top of the closed-beta setup panel in
  `FoiliOS/FoilIOSApp/ContentView.swift`.
- Added focused presentation tests in
  `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`.

## Evidence

- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17'`
  - Passed 29 tests, 0 failures.
- `xcodebuild build -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO`
  - Passed generic iOS device build without installing on a phone.
- `git diff --check`
  - Passed.
- `node /Users/neonwatty/.codex/plugins/cache/goalbuddy/goalbuddy/0.3.8/skills/goalbuddy/scripts/check-goal-state.mjs docs/goals/ios-v0.42-first-run-onboarding-polish/state.yaml`
  - Passed after adding the Worker task contract.
- Simulator semantic UI snapshots proved:
  - First-run state: `Setup not started`, `Save your Groq provider key before recording.`, `Paste the key below, then tap Save key.`
  - Partial state after a dummy non-secret key: `Keyboard not verified`, `Open Foil Keyboard in a text field to verify Full Access.`, `Open a safe text field.`
  - Ready-to-insert state after simulated keyboard health: `Ready to insert`, `A transcript is waiting for Foil Keyboard.`, `Return to a safe text field and tap Insert latest once.`

## Overclaim Scan

The scan found only explicit disclaimers or tests guarding against unsafe
claims:

- `README.md` says not to claim arbitrary app support and does not claim
  Messages delivery.
- `docs/ios-closed-beta-tester-handoff.md` says Messages delivery is not
  claimed and warns not to claim broad iPhone compatibility, Mail support, or
  secure-field support.
- `FoilDictationLoopPresenter.swift` retains the existing narrow-beta copy:
  "not broad iPhone app support."
- New setup-complete test asserts the summary does not contain `Mail support`,
  `Messages delivery`, or `broad iPhone app support`.

## Residual Risk

Physical iPhone proof is still required by the v0.42 oracle before this child
board can be considered complete. Safe preflight found `iPhone-preview` in the
device list, but `devicectl` reported it as `unavailable`, and WDA was not
reachable at `http://127.0.0.1:8100`. Installing this branch on the preview
iPhone also requires explicit operator approval because it is a device install
action.
