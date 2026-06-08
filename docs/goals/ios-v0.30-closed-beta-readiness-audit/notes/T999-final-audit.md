# T999 Final Audit

## Verdict

`go_narrow_internal_beta_with_caveats`

## Strongest Realistic Failure Mode

We could tell testers the iOS app is beta-ready while hiding that the proof is
only for a narrow app-to-keyboard loop, not arbitrary host apps, Mail, delivery,
or private existing Messages threads.

## Evidence That Rules It Out

- `T001-receipt-index.md` maps each supported row to fresh receipts and marks
  Mail as deferred.
- `notes/receipts/installed-app-build.json` proves the preview phone currently
  has build `0.1.0 (11)`, matching source metadata.
- `notes/receipts/github-open-work.json` proves zero open PRs and records Mail
  issue `#12` as the only open repo issue.
- v0.29 Messages receipts prove `sendTapped=false`, exact-once draft insertion,
  draft cleanup, and App Group idle cleanup.
- `T002-go-no-go.md` limits the recommendation to a narrow internal beta and
  lists explicit tester caveats.
- `docs/ios-keyboard-host-app-matrix.md` and `README.md` were updated to avoid
  stale or overbroad claims.

## Final Decision

Proceed with a **small internal TestFlight closed beta** for the narrow Foil iOS
dictation-to-keyboard loop, provided tester copy uses the caveats above.

Do not market or describe this as broad iPhone app compatibility yet.
