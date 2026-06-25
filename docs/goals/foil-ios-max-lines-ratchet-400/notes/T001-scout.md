# T001 Scout: 400-Line Ratchet

## Current Blockers

`scripts/source-line-ratchet.py --json` on the merged 450-line tree reports:

- `max_lines`: 450
- `allowlist_baselines`: `{}`
- `violations`: `[]`
- Largest counted files:
  - `FoiliOS/Shared/FoilKeyboardBridge.swift`: 445 lines
  - `FoiliOS/FoilIOSApp/ContentView.swift`: 443 lines

Only these two files block a 400-line hard gate.

## `FoilKeyboardBridge.swift`

Structure:

- Lines 3-147 are shared model declarations:
  - `FoilKeyboardPhase`
  - `FoilKeyboardSnapshot`
  - `FoilKeyboardStoragePathResult`
  - `FoilKeyboardStorageReport`
  - `FoilKeyboardFullAccessState`
  - `FoilKeyboardHealthReport`
  - `FoilIOSCommandAction`
  - `FoilIOSCommand`
- Lines 149-445 are the bridge implementation and persistence/reporting logic.

Safest extraction:

- Move the shared model declarations to a new `FoilKeyboardBridgeModels.swift`.
- Leave `FoilKeyboardBridge` behavior and persistence code in place.
- Regenerate the Xcode project so the new Shared file is included in both the app and keyboard extension targets.

Risk:

- Low behavioral risk because this is a same-module declaration move.
- Compile/project inclusion is the main failure mode.

Focused tests:

- `FoilIOSTests/FoilKeyboardBridgeTests`
- `scripts/source-line-ratchet.py --json`
- XcodeGen drift check.

## `ContentView.swift`

Structure:

- App shell state and `body` live at lines 4-113.
- Presentation sections live at lines 115-200.
- Refresh and command handling live at lines 202-239.
- Presentation derivation and actions live at lines 261-437.

Safest extraction:

- Move URL and pending-command routing out to a new helper, for example `FoilContentCommandRouter.swift`.
- Keep `ContentView` state private and pass the existing bridge/controllers/refresh closure into the helper.
- Replace the inline `.onOpenURL` switch and `handlePendingCommand()` method body with helper calls.

Why this slice:

- It should remove roughly 45-50 lines from `ContentView`, enough to pass a 400-line cap.
- It avoids broadening `private` state into cross-file extensions.
- It avoids changing presenter semantics, onboarding layout, recovery presentation, or provider credential behavior.

Risk:

- Medium behavioral risk because command routing is side-effectful.
- Strongest realistic failure mode: compile succeeds but deep-link/pending command behavior changes. This should be mitigated by exact logic movement, simulator tests, and full hosted simulator sanity/merge queue proof.

Focused tests:

- `FoilIOSTests/FoilAppLoopPresentationTests`
- `FoilIOSTests/FoilOnboardingReadinessPresentationTests`
- Full `scripts/ios-simulator-sanity.sh` or merge-queue hosted simulator sanity.

## Recommended Worker Package

Objective:

Extract bridge model declarations and ContentView command routing into new files, lower the hard line-count cap to 400, update docs, regenerate the project, and verify the stricter gate.

Allowed files:

- `FoiliOS/Shared/FoilKeyboardBridge.swift`
- `FoiliOS/Shared/FoilKeyboardBridgeModels.swift`
- `FoiliOS/FoilIOSApp/ContentView.swift`
- `FoiliOS/FoilIOSApp/FoilContentCommandRouter.swift`
- `FoiliOS/FoilIOS.xcodeproj/project.pbxproj`
- `scripts/source-line-ratchet.py`
- `docs/ci-workflow-development-plan.md`
- `docs/ios-simulator-sanity-runbook.md`
- `docs/goals/foil-ios-max-lines-ratchet-400/state.yaml`

Verify:

- `python3 -m py_compile scripts/source-line-ratchet.py scripts/source-whitespace-check.py`
- `scripts/source-line-ratchet.py --self-test`
- `scripts/source-whitespace-check.py --self-test`
- `scripts/source-line-ratchet.py --json`
- `scripts/source-whitespace-check.py`
- `cd FoiliOS && xcodegen generate --spec project.yml`
- `git diff --exit-code -- FoiliOS/FoilIOSApp/Generated FoiliOS/FoilKeyboard/Generated`
- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilKeyboardBridgeTests CODE_SIGNING_ALLOWED=NO`
- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilAppLoopPresentationTests CODE_SIGNING_ALLOWED=NO`
- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilOnboardingReadinessPresentationTests CODE_SIGNING_ALLOWED=NO`
- `git diff --check`
- GoalBuddy state checker.

Stop if:

- The cap change needs an allowlist.
- The new files are not included in the expected targets after XcodeGen.
- The router extraction requires broadening `ContentView` state access or changing command semantics.
- Focused tests fail twice for the same reason.
