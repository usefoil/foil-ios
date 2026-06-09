# T003 Healthy Path Blocker - Physical Automation Hardening

Date: 2026-06-09

## Blocker

The board cannot be marked complete because WDA is still unreachable, so the
healthy path cannot be proven.

## Evidence

`scripts/ios-physical-harness.py preflight` classified the current state as
`wda_unreachable` and `safeToTouchHostApps: false`.

The receipt showed:

- `iPhone-preview` present and available;
- `iproxy` present;
- WDA project present;
- redaction self-test passed;
- WDA not ready at `http://127.0.0.1:8100` with `URLError`;
- no host apps, screenshots, raw WDA source, or transcript bodies touched.

## Blocked oracle

The following v0.48 checks remain unproven:

- healthy WDA session creation;
- TestFlight/Foil app launch;
- sterile host fixture launch;
- sanitized source receipt from a real WDA session;
- teardown after a real WDA run.

## Next owner/action

Operator: start or repair WDA, then run
`scripts/ios-physical-harness.py preflight --strict`. Only after it classifies
as `healthy` should a board open any host app.
