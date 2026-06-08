# T001 Onboarding Inventory

## Current Surfaces

- `FoiliOS/FoilIOSApp/ContentView.swift` shows the primary dictation console,
  transcript review, a "Keyboard setup" status section, recovery steps, and
  diagnostics.
- `FoiliOS/Shared/FoilDictationLoopPresenter.swift` owns the app loop copy,
  keyboard copy, transcript review copy, and keyboard-health recovery copy.
- `FoiliOS/FoilKeyboard/KeyboardViewController.swift` already exposes the
  keyboard-side `Dictate in Foil`, `Insert latest`, and `Clear latest` controls.
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift` covers loop,
  keyboard, transcript-review, and keyboard-health presentation states.

## Beta Tester Journey Mapping

- Provider key: present in the app UI as `Groq API key`, save, clear, and a
  provider status row.
- Microphone: present as a dynamic microphone status row.
- Keyboard install: present only as a static row pointing to Keyboard settings.
- Full Access: present as a static row and dynamic keyboard-health row.
- Record/create transcript: present in the dictation console and presenter
  states.
- Return to host app / Insert latest: present in the complete state and keyboard
  copy.
- Reset/recovery: present as reset buttons, transcript review reset, and
  keyboard-health recovery checklist.
- Safe targets/caveats: not present in a first-run checklist; users must infer
  them from docs.

## Gaps

- The setup area is a list of technical status rows, not a clear closed-beta
  checklist.
- There is no in-app safe-target guidance for Notes, Safari, and Messages draft.
- The app does not explicitly say Mail is deferred or Messages is draft-only.
- The checklist content is not presenter-owned, so the beta claim boundary is
  not directly unit-tested.
- Visual hierarchy can be improved without changing entitlements, TestFlight,
  or physical-device requirements.

## Smallest Safe Slice

Create presenter-owned setup checklist and beta guidance data, test it, and
render it in `ContentView` as a clearer setup/checklist section. Keep keyboard
behavior and app/extension entitlements unchanged.

Exact files:

- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`
- `FoiliOS/FoilIOSApp/ContentView.swift`
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`
- `docs/goals/ios-v0.32-ios-app-onboarding-polish/**`
