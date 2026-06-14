# T009 Physical Recovery Receipt

Claim: after WDA recovered on the direct device URL, PR #29 has fresh physical proof that a sterile host field can surface Foil Keyboard with Full Access available, refresh from staged transcript state, and reset back to idle.

Strongest realistic failure mode: WDA could be healthy while the keyboard still shows stale/off recovery state, leaves Insert Latest enabled after reset, or fails to clear the App Group transcript.

Evidence:

- `notes/physical/T009-preflight-device-url.json` and `notes/physical/T009-status-device-url.json` record `http://192.168.1.40:8100` as healthy, with `safeToTouchHostApps=true`, before host-app work.
- `notes/physical/T009-keyboard-refocus-enabled-state.json` proves the sterile field refocus surfaced Foil Keyboard: `foil-keyboard-root` and `foil-keyboard-insert-latest` are present, Insert Latest is disabled for no-transcript state, and the Full Access-off warning is absent.
- `notes/physical/T009-stage-sterile-transcript.json` records a sterile App Group transcript stage using hashes and length only.
- `notes/physical/T009-keyboard-staged-transcript-waiting.json` proves the keyboard refreshed into waiting state after staging: `foil-keyboard-root`, `foil-keyboard-insert-latest`, and `foil-keyboard-clear-latest` are present, with Insert Latest and Clear enabled and recovery warning copy absent.
- `notes/physical/T009-click-clear-latest.json`, `notes/physical/T009-app-group-after-keyboard-clear.json`, and `notes/physical/T009-keyboard-clear-reset-idle.json` prove keyboard Clear returned App Group and keyboard state to idle: App Group `phase=idle`, `hasTranscript=false`, and Insert Latest/Clear disabled.
- `notes/physical/T009-delete-session.json` records WDA session cleanup.

Result: pass. The PR #29 physical blocker for enabled Full Access/refocus and stale/reset keyboard recovery is cleared on the sterile PR29 field.

Residual risk / follow-up: this pass does not prove live provider recording, TestFlight install freshness, or private-app insertion. Raw WDA sources and the sterile transcript body stayed in `/tmp`; committed receipts contain hashes, counts, identifiers, state booleans, and pass/fail assertions only.
