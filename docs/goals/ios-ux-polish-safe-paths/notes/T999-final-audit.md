# T999 Final Audit

Date: 2026-06-19
Decision: `not_complete`
Full outcome complete: `false`

## Summary

The iOS UX polish tranche has one merged improvement, but the full "thorough
review in common apps" outcome is blocked by physical automation availability.

## Completed

- Audited current Foil app, Foil Keyboard, setup readiness, provider route,
  keyboard health, insertion, stale-state, and host-app claim boundaries.
- Merged PR #50:
  <https://github.com/usefoil/foil-ios/pull/50>
- Added tested setup-first ordering for incomplete idle setup states.
- Preserved dictation-first ordering for setup-ready, recording, saved
  recording, processing, and transcript-ready states.
- Re-ran exact-once/stale-state keyboard bridge tests.

## Blocker

Strict physical preflight still fails closed:

- `classification: device_unavailable`
- device present: true
- device state: `unavailable`
- WDA ready: false
- WDA status: `URLError`
- `safeToTouchHostApps: false`

No Safari, Notes, Messages, secure-field, screenshots, raw WDA trees,
transcripts, recordings, or private phone content were touched in this final
audit.

## Missing Evidence

- Current-build physical route/setup walkthrough after PR #50.
- Current-build Foil Keyboard health and Full Access confirmation in a sterile
  host app.
- Current-build Safari exact-once insertion after the UX ordering change.
- Current-build blank Notes editor walkthrough.
- Current-build fake/dedicated Messages draft walkthrough.
- Secure-field rejection after the UX ordering change.

## Resume Condition

Unlock/connect iPhone-preview, confirm Xcode reports it available, restore WDA
at `http://192.168.1.40:8100`, then rerun:

```sh
python3 scripts/ios-physical-harness.py preflight --strict --wda-url http://192.168.1.40:8100
```

Only continue host-app UX receipts if the command reports
`safeToTouchHostApps: true`.
