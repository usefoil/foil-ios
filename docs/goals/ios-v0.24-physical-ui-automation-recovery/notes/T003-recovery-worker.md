# T003 Recovery Worker

## Result

`external_blocker_reproduced`

## Recovery Attempt

The approved non-destructive route was executed:

- Verified no port 8100 listener before recovery.
- Verified the phone did not require operator unlock according to CoreDevice
  lock-state output.
- Verified WDA runner bundles are installed.
- Rebuilt and launched WDA with a clean local DerivedData path:
  `/tmp/foil-ios-v0.24-wda-deriveddata`.

## Evidence

- `notes/receipts/lock-state-attempt.json`
- `notes/receipts/apps-listing-attempt.json`
- `notes/receipts/wda-fresh-deriveddata-attempt.json`
- `notes/receipts/status-after-fresh-deriveddata-attempt.json`

## Outcome

The clean-DerivedData WDA attempt rebuilt and signed the runner, reached
`Running tests`, then failed with the same XCTest automation-mode timeout as the
baseline attempt. Local stale DerivedData is ruled out. WDA still does not serve
on `http://127.0.0.1:8100/status`.

## Next Owner

Operator/Xcode device setup. Confirm Xcode Devices and Simulators has no
outstanding warning for `iPhone-preview`, and confirm Developer Mode/trust or
automation prompts directly on the phone before rerunning WDA.
