# T004 Physical Receipt

Claim: Insert Latest only inserts a fresh complete transcript once, then refuses empty, stale, and non-complete App Group states.

Strongest realistic failure mode: the keyboard UI looks ready but host-field insertion still duplicates text, leaves the App Group insertable, or accepts stale/non-complete transcript state.

Evidence:
- `notes/physical/T004-preflight.json` proves the physical device and WDA were healthy before touching the sterile Safari fixture.
- `notes/physical/T004-install.json` proves the PR #31 debug app bundle was installed on iPhone-preview.
- `notes/physical/T004-stage-complete.json`, `notes/physical/T004-safari-before.json`, `notes/physical/T004-insert-click.json`, `notes/physical/T004-safari-after-insert.json`, and `notes/physical/T004-app-group-after-insert.json` prove a fresh complete sterile transcript exposed an enabled Insert Latest button, inserted into the normal Safari field exactly once, disabled after insertion, and left the App Group idle with no transcript.
- `notes/physical/T004-second-click-attempt.json`, `notes/physical/T004-safari-after-second-click.json`, and `notes/physical/T004-app-group-after-second-click.json` prove a second click attempt did not duplicate inserted text or rehydrate the App Group transcript.
- `notes/physical/T004-reset-no-transcript.json`, `notes/physical/T004-no-transcript-disabled.json`, and `notes/physical/T004-app-group-no-transcript.json` prove the no-transcript state keeps Insert Latest disabled.
- `notes/physical/T004-stage-stale-complete.json`, `notes/physical/T004-app-group-stale-staged.json`, and `notes/physical/T004-stale-disabled.json` prove a stale complete transcript remains hashed in the App Group but is not insertable.
- `notes/physical/T004-stage-processing.json`, `notes/physical/T004-app-group-processing-staged.json`, and `notes/physical/T004-processing-disabled.json` prove a non-complete processing snapshot with transcript text remains non-insertable.
- `notes/physical/T004-reset-final.json` and `notes/physical/T004-app-group-final.json` prove the device was returned to idle/no-transcript state.

Residual risk / follow-up: physical proof used a sterile Safari fixture rather than a private real-world host app, by design. Raw WDA trees and screenshots stayed in `/tmp`; committed receipts contain booleans, hashes, counts, and pass/fail assertions only.
