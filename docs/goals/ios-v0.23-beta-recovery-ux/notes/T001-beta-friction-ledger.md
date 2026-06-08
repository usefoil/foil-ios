# T001 Beta Friction Ledger

## Ledger

| Issue | Source receipt | Impact | Severity | Disposition |
| --- | --- | --- | --- | --- |
| WDA/equivalent physical UI automation unavailable | `docs/goals/ios-v0.23-beta-preflight/notes/receipts/wda-failure.json`; `docs/goals/ios-v0.23-apple-app-matrix/notes/T999-matrix-audit.md` | Blocks fresh Notes, Messages, Mail, Safari insertion proof | blocker | `external_blocker` |
| Provider/key and microphone readiness | `docs/goals/ios-v0.23-beta-preflight/notes/receipts/command-mailbox-proof.json` | Would block dictation if failing | closed | Proven by command-mailbox proof |
| Installed build app-side TestFlight rehearsal | `docs/goals/ios-v0.23-testflight-rehearsal/notes/receipts/command-mailbox-rehearsal.json` | Would block beta if stale/wrong build | closed | Proven on installed build 11 |
| Staged transcript remains after matrix could not run | `docs/goals/ios-v0.23-testflight-rehearsal/notes/receipts/command-mailbox-rehearsal.json` | Could confuse later tests as stale App Group state | important | `operator_cleanup` via harness reset |

## Recommendation

No product UX fix is approved from current evidence. The app-side loop worked:
provider/key, microphone, recording, transcription, App Group bridge, keyboard
full-access health, and installed build metadata all have receipts.

The only beta-blocking issue is external automation: restore WDA or provide an
equivalent physical UI tap/snapshot route. Run one operational cleanup to reset
the staged transcript now that the Apple app matrix cannot consume it.
