# Foil iOS CI Workflow Development Plan

Foil iOS CI should be honest about what hosted GitHub Actions can prove, while
building toward the same hygiene posture used by the stricter TypeScript
projects.

## Required Hosted CI

The first required GitHub Actions layer should be named
`iOS Simulator Sanity (non-physical)` and should run only simulator-safe checks:

- Xcode and simulator destination visibility.
- XcodeGen regeneration plus generated-file drift detection.
- A tracked-file trailing-whitespace check that works on a clean hosted
  checkout.
- Python syntax checks for repo scripts.
- Shell syntax checks for repo shell scripts.
- `scripts/ios-physical-harness.py self-test`.
- `scripts/ios-simulator-sanity.sh`.

The hosted workflow is split into two job names. The current repository ruleset
`main-protection` applies to `~DEFAULT_BRANCH`, requires pull requests, uses the
merge queue, and has strict required status checks for these contexts:

- `Hosted simulator sanity`
- `Repo hygiene ratchet`

Classic branch protection for `main` is not the source of truth here; GitHub's
repository ruleset API is.

This lane proves project visibility, deterministic simulator tests, helper
syntax, redaction fixture behavior, and unsigned device-SDK compilation. It
does not prove physical iPhone install, TestFlight, microphone/provider live
behavior, Full Access, WebDriverAgent, or host-app keyboard insertion.

The simulator sanity script owns phase-level diagnostics for
`project-scheme-visibility`, `simulator-tests`, and
`unsigned-generic-ios-build`. Its per-phase timeouts are shorter than the
hosted job timeout so a stuck `xcodebuild` phase can fail with a named phase and
upload the existing sanitized text artifact.

## Hygiene Ratchet

Foil iOS does not currently have the direct equivalent of TypeScript linting,
Knip, or max-lines gates. Add the hygiene layer in stages so it catches new
regressions without blocking on historical debt first.

1. Add a source file line-count audit that reports the largest Swift, Python,
   shell, and workflow files.
2. Add a ratcheting max-lines check that fails new source files over the chosen
   limit while temporarily allowlisting existing oversized files.
3. Shrink or split the allowlisted files until the allowlist is empty.
4. Promote the rule to a hard max-lines-per-file gate in required CI.

The end state is non-negotiable: required CI should enforce a hard max-lines
per file limit for source and script files. Existing oversized files are a
temporary migration concern, not a permanent exception.

Board 1 established this ratchet with `scripts/source-line-ratchet.py`; Boards 2
through 4 ratcheted it down further.
It counts only `FoiliOS/**/*.swift`, `scripts/**/*.py`, `scripts/**/*.sh`,
`.github/workflows/**/*.yml`, and `.github/workflows/**/*.yaml`. The current
per-file threshold is 350 lines. The temporary oversized allowlist has been
removed; required CI now enforces the hard max-lines rule with no historical
baselines. The repo-hygiene job also runs
`scripts/source-line-ratchet.py --self-test` so the fail-closed behavior for
over-limit files, allowlisted baselines, and missing allowlisted files is covered
by a deterministic fixture before the real checkout is scanned.

Board 1 also uses `scripts/source-whitespace-check.py` instead of relying on
`git diff --check` in hosted CI. A clean GitHub Actions checkout has no local
diff, so the scanner checks tracked text files directly for trailing spaces or
tabs. The repo-hygiene job runs `scripts/source-whitespace-check.py --self-test`
to prove clean text and binary files pass while trailing spaces, tabs, and CRLF
line bodies with trailing whitespace fail.

Board 5 added the first low-noise script-lint analog: `Repo hygiene ratchet`
runs `bash -n scripts/ios-simulator-sanity.sh` so the required hygiene job
proves the simulator sanity shell lane is parseable before running heavier
fixtures and real checkout scans. `shellcheck` passed locally and remains the
next script-lint candidate, but it should not become required until the hosted
install path is pinned or otherwise made deterministic.

The initial migration allowlist was:

- `FoiliOS/FoilIOSApp/ContentView.swift`: 967 lines
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`: 928 lines
- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`: 830 lines
- `scripts/ios-physical-harness.py`: 699 lines

That migration is now complete: `scripts/source-line-ratchet.py --json` reports
an empty `allowlist_baselines` object, a 350-line threshold, and no violations.

Failure artifacts are intentionally narrow: hosted-CI text logs, generated
drift diffs, and sanitized JSON reports only. The workflow does not upload
broad temporary globs, provider keys, App Store Connect keys, raw WDA or
accessibility trees, phone screenshots, recordings, `.ipa`, or `.xcarchive`
artifacts.

## Future Static Analysis

Consider SwiftLint, SwiftFormat, `swift-format`, and Periphery only after a
repo-local configuration and warning surface are understood. Board 5's
`swift-format lint --recursive FoiliOS --no-color-diagnostics` prototype emitted
thousands of warnings, mostly formatting/indentation, so it is advisory-first
rather than required. Periphery is the closest Swift analog to Knip, but it
needs careful configuration around SwiftUI, tests, XcodeGen-generated projects,
and extension entry points before it can be trusted as a required gate.

## Physical Device Lane

The preview iPhone lane must remain separate from hosted CI. It should become a
trusted self-hosted workflow only after runner isolation, device locking,
sanitized artifact allowlists, and receipt redaction are proven. It should not
be required for the merge queue until the runner is stable and intentionally
configured for merge-group tip proof.
