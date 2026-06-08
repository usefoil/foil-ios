# T002 Preflight Judge

## Decision

`operator_needed`

## Rationale

The preflight proves useful current state: device connected, build 11 installed,
App Group idle/no transcript, keyboard health/full access enabled, and Foil app
plus keyboard processes present. It does not prove the full preflight oracle.

The board requires provider/key, microphone, WDA, and keyboard state to be known
before starting TestFlight rehearsal. Keyboard/App Group state is known, but WDA
is not available, and provider/key plus microphone permission cannot be verified
directly without either WDA UI automation or an explicitly approved
command-mailbox recording path.

## Next Action

Restore physical UI automation on `iPhone-preview` so WDA reports ready at
`http://127.0.0.1:8100/status`, then rerun the provider/microphone/app UI
preflight. A narrower alternative is to revise the board to approve a
command-mailbox rehearsal that writes Foil App Group command files and uses a
sterile recording/transcription to prove provider and microphone state.

## Strongest Realistic Failure Mode

The team could proceed because build 11 and keyboard full access look good, but
real beta rehearsal would immediately fail when Codex cannot tap or inspect the
phone, or when provider/microphone state is stale.

## Evidence

- `notes/receipts/wda-failure.json` records two WDA attempts with XCTest
  automation-mode timeout.
- `notes/receipts/status-after-wda-retry.json` records `wda.ready=false`.
- `notes/receipts/app-group-preferences.json` records keyboard health but no
  provider or microphone permission field.
- `notes/T001-preflight-scout.md` lists the exact current-state proof and
  unknowns.
