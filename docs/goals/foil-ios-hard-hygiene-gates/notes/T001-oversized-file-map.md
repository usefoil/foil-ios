# T001 Oversized File Map

## Current Ratchet State

`scripts/source-line-ratchet.py --json` reports `MAX_LINES = 500`, 22 counted files, no current violations, and four temporary allowlist baselines:

- `FoiliOS/FoilIOSApp/ContentView.swift`: 967 lines.
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`: 928 lines.
- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`: 830 lines.
- `scripts/ios-physical-harness.py`: 699 lines.

The next-largest non-allowlisted file is `FoiliOS/Shared/FoilKeyboardBridge.swift` at 445 lines, so allowlist removal should avoid creating a new near-threshold dumping ground.

## Project Inclusion

`FoiliOS/project.yml` uses folder sources:

- `FoilIOS` target includes `FoilIOSApp` and `Shared`.
- `FoilKeyboard` target includes `FoilKeyboard` and `Shared`.
- `FoilIOSTests` includes `FoilIOSTests` and depends on `FoilIOS`.

New Swift files placed under `FoilIOSApp`, `Shared`, or `FoilIOSTests` should be picked up by XcodeGen, but every Worker that adds Swift files should run XcodeGen and generated-drift checks.

## ContentView.swift

Responsibilities:

- Lines 1-23: imports, `ContentView` stored state, bridge/controller ownership, route selection storage, refresh timer.
- Lines 24-167: main `body`, navigation, recovery panel, advanced/support disclosure, URL command handling.
- Lines 169-256: `primaryFlowSections` and `dictationConsole`.
- Lines 258-393: transcript review, recording buttons, provider credential editor.
- Lines 395-637: route-first onboarding, route choices, route detail panes, readiness, tested targets.
- Lines 639-682: diagnostic buttons and keyboard recovery checklist.
- Lines 684-741: refresh, pending command handling, retry, provider-key save/clear.
- Lines 743-896: presentation/state derivation from bridge/audio/transcription/presenter state.
- Lines 898-945: action dispatch and row helpers.
- Lines 948-963: SwiftUI `Color` mapping for `FoilLoopTone`.
- Lines 965-967: preview.

Split candidates:

- `FoilLoopTone+Color.swift` under `FoilIOSApp` for the SwiftUI-only `Color` mapping.
- Child views or same-file-to-extension extractions for dictation console, transcript review, onboarding route panels, diagnostics/recovery, and row helpers.

Risk notes:

- Cross-file `extension ContentView` cannot access many currently `private` state properties and helper methods without access changes. A safe Worker should either extract child `View` structs with explicit values/actions or intentionally relax selected members to internal with focused review.
- This is UI-visible and should be verified with `scripts/ios-simulator-sanity.sh`; if view decomposition is extensive, consider simulator screenshots or focused UI/runtime inspection later.
- ContentView is not the safest first package because the access-control surface is larger than the presenter/test split.

## FoilDictationLoopPresenter.swift

Responsibilities:

- Lines 3-187: value types and presentation DTOs (`FoilLoopTone`, app/keyboard action enums, app/keyboard/storage/transcript/setup/onboarding/beta presentation structs, microphone setup state).
- Lines 189-203: presenter constants and route IDs.
- Lines 204-318: setup readiness presentation.
- Lines 320-453: route choice, Mac pairing preview, iPhone setup checklist, advanced support, beta guidance.
- Lines 455-471: transcript review presentation.
- Lines 473-552: keyboard health and storage health presentation.
- Lines 554-636: onboarding readiness presentation.
- Lines 638-749: app presentation and setup prioritization.
- Lines 751-830: keyboard presentation for the extension.

Split candidates:

- `FoilDictationLoopPresentationModels.swift`: lines 3-187 DTOs/enums.
- `FoilDictationLoopSetupPresenter.swift`: setup readiness, route choices, Mac pairing preview, iPhone checklist, advanced support, beta guidance, onboarding readiness.
- `FoilDictationLoopAppPresenter.swift`: transcript review, app presentation, setup prioritization.
- `FoilDictationLoopKeyboardPresenter.swift`: keyboard health, storage health, keyboard presentation.
- Keep `FoilDictationLoopPresenter.swift` as constants plus a small namespace declaration if desired.

Risk notes:

- These declarations are internal by default and live in `Shared`; cross-file extensions on `FoilDictationLoopPresenter` can preserve call sites and avoid behavior changes.
- Because `Shared` is compiled into both app and keyboard targets, split files must remain free of SwiftUI and app-only dependencies.
- This is the safest high-impact first package: no private cross-file access issue, strong existing tests, and one package can bring `FoilDictationLoopPresenter.swift` below 500 or retire the original file entirely.

## FoilDictationLoopPresentationTests.swift

Responsibilities mirror `FoilDictationLoopPresenter`:

- Lines 5-126: setup readiness tests.
- Lines 128-207: route, Mac preview, iPhone setup checklist, advanced support tests.
- Lines 209-387: onboarding readiness and beta guidance tests.
- Lines 389-635: app presentation, setup prioritization, transcript review, failure/provider recovery tests.
- Lines 637-791: keyboard presentation tests.
- Lines 793-927: storage health and keyboard health tests.

Split candidates:

- `FoilSetupReadinessPresentationTests.swift`.
- `FoilSetupRoutePresentationTests.swift`.
- `FoilOnboardingReadinessPresentationTests.swift`.
- `FoilAppLoopPresentationTests.swift`.
- `FoilKeyboardLoopPresentationTests.swift`.
- `FoilHealthPresentationTests.swift`.

Risk notes:

- Test splitting is mechanically safe if fixtures remain local or are extracted to a small helper file below 500 lines.
- Avoid weakening coverage by merging assertions into broad smoke tests. Keep current assertions while moving test methods.
- Splitting this test file in the same Worker package as presenter source gives immediate verification coverage and removes a second allowlist baseline.

## scripts/ios-physical-harness.py

Responsibilities:

- Lines 26-40: physical-device/WDA constants.
- Lines 43-97: command, JSON, and HTTP helpers.
- Lines 100-150: WDA readiness, device-line parsing, snapshot summary/redaction helpers.
- Lines 153-224: App Group copy helpers, process-summary redaction.
- Lines 227-300: preflight classification and receipt.
- Lines 303-410: WDA command/status/session/delete/fetch-source commands.
- Lines 413-511: App Group stage/reset/summary and sanitized receipt wrapper.
- Lines 514-600: fixture-only self-test.
- Lines 603-679: CLI parser.
- Lines 682-699: main and error handling.

Split candidates:

- `scripts/ios_physical_harness_core.py`: shared constants, hashing, JSON/process helpers, HTTP/WDA readiness helpers.
- `scripts/ios_physical_harness_app_group.py`: snapshot payload/summary and App Group copy/stage/reset/summary.
- `scripts/ios_physical_harness_wda.py`: WDA command/status/session/fetch-source.
- `scripts/ios_physical_harness_self_test.py`: fixture self-test.
- Keep `scripts/ios-physical-harness.py` as CLI parser/entrypoint.

Risk notes:

- This file is privacy-sensitive. Any split must preserve no raw transcript bodies, no raw WDA source printing, sanitized hashes/counts, and the fixture self-test behavior.
- New Python helper modules under `scripts/` are counted by the ratchet; keep each below 500 and py_compile all touched modules.
- This is a good second or third package, after the presenter/test split, because it has more privacy and command-line compatibility risk.

## Verification Commands

For Swift presenter/test splits:

```bash
cd FoiliOS && xcodegen generate --spec project.yml
git diff --exit-code -- FoiliOS/FoilIOS.xcodeproj FoiliOS/FoilIOSApp/Generated FoiliOS/FoilKeyboard/Generated
scripts/source-line-ratchet.py
scripts/source-whitespace-check.py
git diff --check
scripts/ios-simulator-sanity.sh
```

For a focused presenter/test pass before the full sanity script, use:

```bash
xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination "platform=iOS Simulator,name=iPhone 17" -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests
```

For Python harness splits:

```bash
python3 -m py_compile scripts/ios-physical-harness.py scripts/ios-physical-wda-evidence.py <new-helper-modules>
scripts/ios-physical-harness.py self-test
scripts/source-line-ratchet.py
scripts/source-whitespace-check.py
git diff --check
```

## Scout Recommendation

Start with a combined presenter/test split:

- Move presenter DTOs and static presentation domains into several `Shared` files while preserving `FoilDictationLoopPresenter.*` call sites.
- Split `FoilDictationLoopPresentationTests.swift` into domain-specific test files without changing assertions.
- Verify with XcodeGen drift check, source ratchet, whitespace, focused presenter tests, and full `scripts/ios-simulator-sanity.sh`.

Expected impact: removes or materially shrinks two of the four allowlist baselines with low behavior risk and strong automated coverage.
