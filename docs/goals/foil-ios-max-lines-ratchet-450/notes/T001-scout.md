# T001: 450-Line Ratchet Scout

Task: `T001`
Kind: `scout`
Status: `current`

## Summary

The 450-line ratchet is currently blocked by exactly one counted file: `FoiliOS/FoilIOSApp/ContentView.swift` at 480 lines. `FoiliOS/Shared/FoilKeyboardBridge.swift` is 445 lines and would remain under a 450-line ceiling. The safest first Worker package is to extract `ContentView`'s self-contained recovery panel into a sibling SwiftUI view, remove redundant helper wrappers, lower `scripts/source-line-ratchet.py` from 500 to 450, update docs, and regenerate/check XcodeGen project membership if the new Swift file changes the project file.

## Current Blockers

- `scripts/source-line-ratchet.py --json` on `main` reports `max_lines: 500`, `allowlist_baselines: {}`, `violations: []`, and 44 counted files.
- Largest counted files:
  - `FoiliOS/FoilIOSApp/ContentView.swift`: 480 lines.
  - `FoiliOS/Shared/FoilKeyboardBridge.swift`: 445 lines.
  - `scripts/ios-physical-wda-evidence.py`: 367 lines.
- A hard 450-line cap would only fail on `ContentView.swift`.

## ContentView Structure

- Lines 1-23: imports, bridge/controllers, app state, route AppStorage, refresh timer.
- Lines 24-141: main navigation/body, recovery section, advanced support, URL handling, refresh hooks.
- Lines 143-237: section builders for primary flow, dictation console, transcript review, provider editor, route-first panel, tested targets, keyboard recovery checklist.
- Lines 239-296: refresh, pending command handling, retry, provider key save/clear.
- Lines 298-451: presentation/state derivation from storage, recovery, microphone, keyboard, onboarding, app stage, transcript review.
- Lines 453-474: primary/secondary action dispatch.
- Lines 478-480: preview.

## Safe Extraction Candidate

The recovery block in `ContentView.body` is a good extraction candidate:

- It is self-contained UI with explicit inputs: recovery message, provider-key recovery flag, keyboard recovery steps, retry eligibility, provider credential editor, retry closure, reset closure.
- It already delegates subpanels to existing views (`FoilSetupRow`, `FoilKeyboardRecoveryChecklist`, `FoilTestedTargetsPanel`, `FoilStatusRow`).
- Moving it to `FoilRecoverySection.swift` avoids widening access control for `ContentView` state and avoids semantic presenter changes.
- It should remove enough lines from `ContentView.swift` to get under 450 while keeping the new file comfortably below the cap.

Avoid a cross-file `extension ContentView` for private helpers: current state and helpers are `private`, so an extension would require broader access changes. Prefer a child view with explicit values and closures.

## Project Inclusion

`FoiliOS/project.yml` uses folder sources:

- `FoilIOS` target includes `FoilIOSApp` and `Shared`.
- `FoilKeyboard` target includes `FoilKeyboard` and `Shared`.
- `FoilIOSTests` includes `FoilIOSTests`.

New Swift files under `FoilIOSApp` should be picked up by XcodeGen, but the Worker should run `cd FoiliOS && xcodegen generate --spec project.yml` if `xcodegen` is available and then check drift under:

- `FoiliOS/FoilIOS.xcodeproj`
- `FoiliOS/FoilIOSApp/Generated`
- `FoiliOS/FoilKeyboard/Generated`

If XcodeGen is unavailable locally, the Worker should at minimum run compile/test commands that prove the checked-in project includes the new file, and record the local XcodeGen skip explicitly.

## Verification Surface

Primary verification:

- `python3 -m py_compile scripts/source-line-ratchet.py scripts/source-whitespace-check.py`
- `scripts/source-line-ratchet.py --self-test`
- `scripts/source-whitespace-check.py --self-test`
- `scripts/source-line-ratchet.py --json`
- `scripts/source-whitespace-check.py`
- `git diff --check`
- `node /Users/neonwatty/.codex/plugins/cache/goalbuddy/goalbuddy/0.3.9/skills/goalbuddy/scripts/check-goal-state.mjs docs/goals/foil-ios-max-lines-ratchet-450/state.yaml`

Swift verification:

- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilAppLoopPresentationTests`
- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilOnboardingReadinessPresentationTests`
- Full `scripts/ios-simulator-sanity.sh` before PR if time allows, otherwise rely on merge-queue required `Hosted simulator sanity` and record the local skip.

## Recommended Worker Package

Objective: Extract the recovery panel from `ContentView` into `FoilRecoverySection`, lower the hard line-count cap to 450, update docs, and verify the stricter gate locally.

Allowed files:

- `FoiliOS/FoilIOSApp/ContentView.swift`
- `FoiliOS/FoilIOSApp/FoilRecoverySection.swift`
- `FoiliOS/FoilIOS.xcodeproj/project.pbxproj`
- `scripts/source-line-ratchet.py`
- `docs/ci-workflow-development-plan.md`
- `docs/ios-simulator-sanity-runbook.md`
- `docs/goals/foil-ios-max-lines-ratchet-450/state.yaml`

Stop if:

- The extraction requires changing presenter semantics or broadening `ContentView` internals instead of passing explicit values/closures.
- The cap change needs an allowlist.
- The new Swift file cannot be included in the app target locally.
- Targeted Swift tests fail twice for the same reason.

## Board Receipt Snippet

```yaml
receipt:
  result: done
  note: notes/T001-scout.md
  summary: "450-line Scout found exactly one blocker: `ContentView.swift` at 480 lines. Recommended extracting the recovery panel into `FoilRecoverySection`, lowering `MAX_LINES` to 450, updating docs, and verifying with line/whitespace self-tests plus focused Swift tests."
```
