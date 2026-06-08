# T001 Receipt Index

## Parent Criteria Mapping

| Criterion | Status | Evidence |
| --- | --- | --- |
| Device/build preflight known | Proven | `docs/goals/ios-v0.23-beta-preflight/notes/T004-final-audit.md` |
| Installed Foil iOS build known | Proven | `docs/goals/ios-v0.23-testflight-rehearsal/notes/receipts/build-installed.json` |
| Provider/key and microphone current readiness | Proven | `docs/goals/ios-v0.23-beta-preflight/notes/receipts/command-mailbox-proof.json` |
| App-side installed-build record/transcribe | Proven | `docs/goals/ios-v0.23-testflight-rehearsal/notes/receipts/command-mailbox-rehearsal.json` |
| Keyboard full access / App Group bridge state | Proven | `docs/goals/ios-v0.23-beta-preflight/notes/receipts/app-group-preferences.json` |
| Notes insertion row | Blocked | `docs/goals/ios-v0.23-apple-app-matrix/notes/T999-matrix-audit.md` |
| Messages/iMessage insertion row | Blocked | `docs/goals/ios-v0.23-apple-app-matrix/notes/T999-matrix-audit.md` |
| Mail insertion row | Blocked | `docs/goals/ios-v0.23-apple-app-matrix/notes/T999-matrix-audit.md` |
| Safari text/secure rows | Blocked | `docs/goals/ios-v0.23-apple-app-matrix/notes/T999-matrix-audit.md` |
| Recovery/cleanup | Proven | `docs/goals/ios-v0.23-beta-recovery-ux/notes/receipts/recovery-cleanup.json` |
| Product UX blocker disposition | Proven no product fix | `docs/goals/ios-v0.23-beta-recovery-ux/notes/T999-final-audit.md` |

## Missing Or Weak Proof

- Fresh v0.23 Apple host-app insertion proof is missing for all required rows.
- The missing proof is not because of app-side transcription; it is because
  WDA/equivalent physical UI automation is unavailable.
- Prior boards contain historical Notes/Safari/Messages evidence, but the v0.23
  conveyor required fresh Apple baseline rehearsal proof, so those historical
  rows are not counted as current pass evidence.
