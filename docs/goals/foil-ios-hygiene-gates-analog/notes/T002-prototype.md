# T002 Scout: Hygiene Check Prototypes

## Required-Now Candidate

`bash -n scripts/ios-simulator-sanity.sh`:

- result: pass
- repo scope: one tracked shell script, `scripts/ios-simulator-sanity.sh`
- hosted feasibility: no external dependency; GitHub-hosted macOS has `bash`
- signal: syntax/parse correctness for the repo's simulator sanity shell lane
- risk: narrower than shellcheck; it does not catch portability, quoting, or
  style issues

Recommendation: required now in `Repo hygiene ratchet` as a deterministic shell
syntax gate.

## Advisory Candidate

`shellcheck scripts/ios-simulator-sanity.sh`:

- result: pass locally
- local version: `0.11.0`
- hosted feasibility: not yet proven or pinned in this repo
- signal: stronger shell lint than `bash -n`
- risk: making this required through Homebrew or an action would introduce an
  unpinned external install path unless Worker pins the tool and checksum

Recommendation: document as the next script-lint candidate, but do not require
in this Worker package unless a pinned install plan is added.

## Advisory/Deferred Candidate

`swift-format lint --recursive FoiliOS --no-color-diagnostics`:

- exit code: 0
- output lines: 4,379
- top findings:
  - `Indentation`: 4,119
  - `LineLength`: 211
  - `TrailingComma`: 22
  - `AddLines`: 17
  - `RemoveLine`: 7
  - `ReplaceForEachWithForLoop`: 1
  - `NoAccessLevelOnExtensionDeclaration`: 1

The command exits zero because default lint emits warnings unless `--strict` is
used. The current output is too noisy to make required. A future board should
choose a repo-local config, possibly start with advisory artifacts, and only
turn on `--strict` after the warning surface is intentionally reduced.

Recommendation: advisory first, not required now.

## Deferred Candidate

Periphery:

- not installed locally;
- no repo config exists;
- previous Judge receipt already flagged SwiftUI/test/XcodeGen/app-extension
  false positives.

Recommendation: defer to a dedicated false-positive/configuration board.

## Worker Recommendation

Add the deterministic `bash -n` shell syntax check to the required
`Repo hygiene ratchet` job and document it as the first safe script-lint analog.
Keep shellcheck and swift-format in docs as advisory/prototype follow-ups.
