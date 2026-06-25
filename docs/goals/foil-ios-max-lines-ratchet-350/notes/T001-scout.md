# T001 Scout: 350-Line Ratchet Map

## Current Gate

`scripts/source-line-ratchet.py --json` reports:

- `max_lines`: 400
- `allowlist_baselines`: `{}`
- `violations`: `[]`
- `total_files`: 48

## Candidate Cap Blockers

For a 375-line cap:

- `FoiliOS/FoilIOSApp/ContentView.swift`: 400 lines, 25 over.

For a 350-line cap:

- `FoiliOS/FoilIOSApp/ContentView.swift`: 400 lines, 50 over.
- `scripts/ios-physical-wda-evidence.py`: 367 lines, 17 over.

Near-cap files that do not block 350 but should shape follow-up planning:

- `FoiliOS/Shared/FoilDictationLoopSetupPresenter.swift`: 338 lines.
- `FoiliOS/FoilIOSApp/FoilOnboardingPanels.swift`: 335 lines.

## ContentView Structure

`ContentView.swift` is now 400 lines exactly. The top-level view still owns:

- app/keyboard bridge state and timer wiring, lines 5-18;
- body and primary view composition, lines 20-178;
- command handling wrappers, lines 180-220 and 377-399;
- presentation/derived state helpers, lines 222-375.

The safest next extraction is not another command router move. Board 3 already handled that. The low-risk remaining extraction is presentation-support logic that takes values and returns strings/states:

- `storageReportSummary`, lines 222-228;
- `recoveryMessage`, lines 230-254;
- `handoffGuidance`, lines 256-271;
- `microphonePermissionSummary`, lines 280-291;
- `microphoneSetupState`, lines 297-308.

Those helpers can move to a new app file without broadening `ContentView` private state if implemented as static functions that accept the already-computed inputs. This should remove roughly 50-60 lines from `ContentView` while preserving the existing state ownership.

## WDA Evidence Script Structure

`scripts/ios-physical-wda-evidence.py` is 367 lines. It is privacy-sensitive because it converts WDA source into sanitized receipts.

Low-risk extraction point:

- move pure XML/source helper functions into a new sibling module:
  - `sha256_text`
  - `short_hash`
  - `load_wda_source`
  - `xml_nodes`
  - `has_identifier`
  - `identifier_attribute_matches`
  - `value_count`
  - `value_contains`
  - `accessible_text_contains`

This keeps CLI argument parsing and receipt assembly in the script while moving pure, deterministic parsing helpers out. It should reduce the script well below 350 without touching private physical-device artifacts or changing receipt schema.

## Recommended Next Cap

Recommend going directly to 350 rather than using 375 as an intermediate.

Rationale:

- 375 only forces a small `ContentView` split and leaves the WDA script as immediate next debt.
- 350 has exactly two blockers, both with clean extraction points.
- The WDA extraction is pure parser/helper movement and can be verified with a sterile synthetic fixture.
- The ContentView extraction can preserve private state ownership by passing values into static helper functions.

## Recommended Worker Package

Objective:

Extract `ContentView` presentation-support helpers and WDA XML/source helper functions into new files, lower the hard max-lines cap to 350 with no allowlist, update docs, regenerate Xcode, and verify the stricter gate.

Allowed files:

- `FoiliOS/FoilIOSApp/ContentView.swift`
- `FoiliOS/FoilIOSApp/FoilContentPresentationSupport.swift`
- `FoiliOS/FoilIOS.xcodeproj/project.pbxproj`
- `scripts/ios-physical-wda-evidence.py`
- `scripts/ios_physical_wda_evidence_core.py`
- `scripts/source-line-ratchet.py`
- `docs/ci-workflow-development-plan.md`
- `docs/ios-simulator-sanity-runbook.md`
- `docs/goals/foil-ios-max-lines-ratchet-350/state.yaml`

Verify:

- `python3 -m py_compile scripts/source-line-ratchet.py scripts/source-whitespace-check.py scripts/ios-physical-wda-evidence.py scripts/ios_physical_wda_evidence_core.py`
- `scripts/source-line-ratchet.py --self-test`
- `scripts/source-whitespace-check.py --self-test`
- `scripts/source-line-ratchet.py --json`
- `scripts/source-whitespace-check.py`
- sterile synthetic WDA fixture through `scripts/ios-physical-wda-evidence.py`
- `cd FoiliOS && xcodegen generate --spec project.yml`
- `git diff --exit-code -- FoiliOS/FoilIOSApp/Generated FoiliOS/FoilKeyboard/Generated`
- focused simulator tests for app presentation, health, setup readiness, and onboarding readiness
- `scripts/ios-simulator-sanity.sh`
- `git diff --check`
- GoalBuddy checker

Stop if:

- The cap change needs an allowlist.
- The ContentView extraction requires broadening state access or moving state ownership.
- The WDA helper extraction changes receipt schema or emits private raw content.
- The new Swift file is not included by XcodeGen.
- Verification fails twice for the same reason.
