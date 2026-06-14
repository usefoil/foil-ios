# T005 Enabled Path Receipt

Claim: after the operator enabled Foil Keyboard Full Access, the physical keyboard can verify enabled health in a sterile host field, expose Insert Latest only when transcript state is waiting, and reset back to idle without overclaiming setup readiness.

Strongest realistic failure mode: the keyboard could still be stuck in the old Full Access-off state, or it could enable Insert Latest/Clear from stale state and fail to clear the App Group transcript.

Evidence:
- `notes/physical/T005-preflight-healthy.json` proves iPhone-preview and WDA were healthy before touching the sterile fixture.
- `notes/physical/T005-safari-fixture-keyboard-visible.json` proves the sterile Safari fixture and Foil Keyboard were visible, while forbidding the Full Access-off recovery copy.
- `notes/physical/T005-reset-enabled-path.json`, `notes/physical/T005-app-group-after-reset.json`, and `notes/physical/T005-keyboard-enabled-reset-idle.json` prove reset/idle state with Insert Latest and Clear disabled for no-transcript state.
- `notes/physical/T005-stage-enabled-transcript.json`, `notes/physical/T005-app-group-after-stage.json`, and `notes/physical/T005-keyboard-enabled-transcript-waiting.json` prove a sterile transcript makes Insert Latest and Clear enabled with Full Access on.
- `notes/physical/T005-app-group-after-keyboard-clear.json` and `notes/physical/T005-keyboard-clear-reset-idle.json` prove the keyboard Clear action returns App Group/keyboard state to idle.

Result: pass. The #29 physical blocker for enabled Full Access/refocus/reset recovery is cleared.

Residual risk / follow-up: this receipt does not prove live provider recording or onboarding completion; those belong to #27/#30. Raw WDA source stayed in `/tmp`; committed receipts contain hashes, counts, booleans, and pass/fail assertions only.
