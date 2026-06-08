# T999 Final Audit

## Decision

`external_blocker`

## Strongest Realistic Failure Mode

We might believe physical UI automation was recovered because WDA rebuilt and
the runner launched, while the actual tap/snapshot server still never became
available.

## Evidence That Rules It Out

- `notes/receipts/wda-start-attempt.json` records a baseline WDA attempt that
  reached `Running tests`, then timed out while enabling automation mode.
- `notes/receipts/wda-fresh-deriveddata-attempt.json` records a second attempt
  using clean local DerivedData that reached the same failure stage.
- `notes/receipts/status-after-fresh-deriveddata-attempt.json` records
  `wda.ready=false` after the recovery attempt.
- T004 is blocked before any host app is opened, so no Apple app insertion row
  is falsely claimed.

## What Is Proven

- The preview iPhone is visible through CoreDevice and returns to available
  state after failed WDA attempts.
- The WDA project and local signing path are present enough to build, sign, and
  launch the runner.
- The failure boundary is XCTest enabling automation mode on the physical
  device, not Foil product code, app-side command-mailbox control, provider
  setup, or keyboard App Group state.

## What Remains

Physical UI automation is still blocked. The next action is operator-side
device/Xcode preparation: verify `iPhone-preview` in Xcode Devices and
Simulators, confirm Developer Mode/trust/automation prompts on-device, then
rerun the WDA command until `http://127.0.0.1:8100/status` returns JSON.

## Next Board

Once WDA or equivalent physical UI control is ready, run the Apple host-app
matrix board for Notes, Messages/iMessage sterile thread, Mail sterile compose,
Safari normal field, and Safari secure field.
