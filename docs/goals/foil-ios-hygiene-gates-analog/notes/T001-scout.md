# T001 Scout: iOS Hygiene Gates Analog Map

## Current Required Gates

Required hosted CI lives in `.github/workflows/ios-simulator-sanity.yml`:

- `Hosted simulator sanity` on `macos-15`
  - checks Xcode/simulator visibility;
  - selects a hosted simulator;
  - installs pinned XcodeGen `2.45.4` with SHA-256 verification;
  - regenerates the Xcode project;
  - checks generated project drift;
  - runs `scripts/ios-simulator-sanity.sh`.
- `Repo hygiene ratchet` on `macos-15`
  - runs tracked-file trailing whitespace scan;
  - compiles Python scripts;
  - runs hygiene script self-tests;
  - runs physical harness fixture self-test only;
  - runs the hard source max-lines ratchet.

`docs/ios-simulator-sanity-runbook.md` names `Hosted simulator sanity` and
`Repo hygiene ratchet` as the required repository-ruleset contexts.

## Current Hygiene State

`scripts/source-line-ratchet.py --json` reports:

- `max_lines`: 350
- `allowlist_baselines`: `{}`
- `total_files`: 51
- `violations`: `[]`

Largest counted files:

- `FoiliOS/FoilIOSApp/ContentView.swift`: 350 lines
- `FoiliOS/Shared/FoilDictationLoopSetupPresenter.swift`: 338 lines
- `FoiliOS/FoilIOSApp/FoilOnboardingPanels.swift`: 335 lines
- `scripts/ios-physical-wda-evidence.py`: 315 lines
- `FoiliOS/Shared/FoilKeyboardBridge.swift`: 299 lines

Existing custom hygiene scripts:

- `scripts/source-whitespace-check.py`
- `scripts/source-line-ratchet.py`

No repo-local SwiftLint, SwiftFormat, swift-format, Periphery, Mint, Brewfile,
Package.swift, shellcheck, ruff, mypy, or pyright configuration was found.

## Local Tool Availability

Available locally:

- `swift-format` at `/opt/homebrew/bin/swift-format`, version `602.0.0`
- `shellcheck` at `/opt/homebrew/bin/shellcheck`, version `0.11.0`

Missing locally:

- `swiftformat`
- `swiftlint`
- `periphery`
- `ruff`
- `mypy`
- `pyright`

## Candidate Analog Map

Max-lines:

- Already required and hard at 350 with no allowlist.
- Should not be reduced inside this board; the top file is exactly 350, so any
  lower cap needs a separate ratchet board with Scout/Judge extraction planning.

Whitespace:

- Already required and deterministic via a repo-local tracked-file scanner.

Python/script syntax:

- Python syntax checks are already required.
- `shellcheck` is the strongest immediate analog for shell script linting
  because the repo currently has one shell script, `scripts/ios-simulator-sanity.sh`,
  and shellcheck is deterministic.
- Hosted CI feasibility still needs proof: local availability is not enough.
  If selected, Worker should either install a pinned/known shellcheck path in CI
  or create a repo-local wrapper/check that fails clearly when unavailable.

Swift formatting/linting:

- `swift-format` is locally available and supports `lint --recursive`.
- Default `swift-format dump-configuration` is broad and opinionated:
  indentation, ordered imports, numeric literal grouping, no block comments,
  early style rules, file-scoped privacy, etc.
- This is not safe to require without a prototype report and probably a
  checked-in config. It may be a good advisory candidate first.

SwiftLint and SwiftFormat:

- Not present locally and no repo config exists.
- They may still be viable later, but should not become required without a
  configuration/baseline pass.

Periphery:

- Closest analog to Knip, but previous board evidence already flagged false
  positives around SwiftUI, tests, app-extension entry points, and XcodeGen.
- Not present locally and no config exists.
- Should be advisory/prototype only, not required in this tranche.

## Risk Map

- Required swift-format lint could fail on broad style preferences rather than
  high-signal maintainability issues.
- Required Periphery could flag SwiftUI/test/keyboard-extension entry points as
  unused unless configured carefully.
- Required shellcheck is likely lower risk, but CI install/pinning and current
  output must be proven before Judge approves it.
- Adding another job/context may require ruleset updates; extending the existing
  `Repo hygiene ratchet` job avoids changing required-check names.

## Recommended Next Scout

Run read-only/advisory prototypes:

- `shellcheck scripts/ios-simulator-sanity.sh`
- `swift-format lint --recursive FoiliOS --no-color-diagnostics`
- optional targeted `swift-format lint` with a narrow config if default output
  is noisy

Then recommend one of:

- required now: shellcheck in `Repo hygiene ratchet`, if local and hosted
  installation story is simple and output is clean;
- advisory first: swift-format lint report;
- defer: Periphery until a dedicated false-positive board.
