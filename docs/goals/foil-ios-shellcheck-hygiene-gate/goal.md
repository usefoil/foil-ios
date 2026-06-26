# Foil iOS Shellcheck Hygiene Gate

## Outcome

Promote shell script linting from local/advisory evidence to an honest
GitHub-hosted CI gate only if the install path and warning surface are
deterministic enough for required branch protection.

## Context

Board 5 added `bash -n scripts/ios-simulator-sanity.sh` to the existing
required `Repo hygiene ratchet` job. Local Scout evidence showed
`shellcheck scripts/ios-simulator-sanity.sh` passes with ShellCheck 0.11.0, but
Judge deferred making it required because the hosted install/pinning story had
not been proven.

## Non-Goals

- Do not add physical iPhone, TestFlight, WDA, provider-key, IPA, archive, or
  private-device evidence.
- Do not add noisy Swift formatting, SwiftLint, or Periphery gates in this
  tranche.
- Do not add a new required status context unless Judge proves that is safer
  than extending `Repo hygiene ratchet`.
- Do not weaken existing simulator-safe, CodeQL, generated-project drift,
  whitespace, Python syntax, physical fixture, shell syntax, or 350-line
  ratchet coverage.

## Oracle

The tranche is complete when either:

- a merge-queued PR lands with a deterministic ShellCheck gate in required CI,
  with hosted PR checks and merge-group proof; or
- Judge records that no deterministic ShellCheck path is honest yet and the
  advisory/deferred state lands with receipts.

In both paths, the GoalBuddy checker must pass and
`scripts/source-line-ratchet.py --json` must still report `max_lines` 350, an
empty allowlist, and no violations.

