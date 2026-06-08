# T003 Cleanup Worker

## Claim

The staged transcript left by the TestFlight rehearsal was cleared after the
Apple app matrix could not consume it.

## Evidence

- Before cleanup: App Group `phase=complete`, `hasTranscript=true`.
- `scripts/ios-physical-harness.py reset-transcript` ran successfully.
- After cleanup: App Group `phase=idle`, `hasTranscript=false`.

## Receipt

- `notes/receipts/recovery-cleanup.json`

## Residual Risk

This does not fix WDA. It only prevents stale staged transcript state from
confusing later runs.
