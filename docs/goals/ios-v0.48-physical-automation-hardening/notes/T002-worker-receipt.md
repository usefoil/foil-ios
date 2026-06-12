# T002 Worker Receipt - Physical Automation Hardening

Date: 2026-06-09

## Claim

`scripts/ios-physical-harness.py preflight` now gives autonomous runs a
privacy-safe physical automation gate.

## Changes

- Added `preflight` command with sanitized classification:
  `healthy`, `device_unavailable`, `tooling_missing`,
  `redaction_self_test_failed`, or `wda_unreachable`.
- Added `--strict` mode that exits non-zero unless the classification is
  `healthy`.
- Included fixture-only redaction self-test status in the preflight receipt.
- Included automation-process count and line hashes without printing command
  lines.
- Documented preflight usage in `docs/ios-physical-automation-runbook.md`.

## Evidence

- `scripts/ios-physical-harness.py self-test` passed all fixture-only privacy
  checks.
- `scripts/ios-physical-harness.py preflight` returned
  `classification: wda_unreachable`, `safeToTouchHostApps: false`, with
  iPhone-preview present, `iproxy` present, WDA project present, redaction
  self-test passed, and no host apps/screenshots/raw source/transcript bodies
  touched.
- `scripts/ios-physical-harness.py preflight --strict` exited 1 in the current
  WDA-unreachable state.
- `scripts/ios-physical-harness.py --help` and
  `scripts/ios-physical-harness.py preflight --help` show the new command.

## Residual risk

This proves the strongest unhealthy path. It does not prove a healthy WDA
session, TestFlight launch, Foil launch, host fixture launch, or teardown after
a real physical run.
