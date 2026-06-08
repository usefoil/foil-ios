# T001 Baseline Scout

## Decision

`automation_mode_failure_reproduced`

## Evidence

- `notes/receipts/status-baseline.json` records `iPhone-preview` present and
  available through `devicectl`, the WDA project present, `iproxy` present, and
  localhost WDA not ready.
- `notes/receipts/wda-command.txt` records the exact WDA launch command.
- `notes/receipts/wda-start-attempt.json` records the fresh WDA attempt:
  build/sign/install reached `Running tests`, then exited 65 with
  `Timed out while enabling automation mode`.
- `notes/receipts/status-after-wda-attempt.json` records the device available
  again after the failed test and WDA still not ready.
- `notes/receipts/device-info-attempt.json` proves CoreDevice device-info JSON
  was collectable but was not committed raw.
- `notes/receipts/xcodebuildmcp-capability.json` records that XcodeBuildMCP was
  checked, but no physical-device UI automation path is configured in this
  session.

## Failure Boundary

The failure is not Foil transcription, provider setup, keyboard App Group
state, WDA project presence, signing, install, or initial runner launch. The
fresh failure occurs when XCTest tries to enable UI automation mode on the
physical device.

## Root-Cause Hypothesis For Judge

The most likely root cause is device-side or Xcode/CoreDevice automation-mode
state: the phone is paired and available, but XCTest cannot enable automation
for the runner. The next route should be non-destructive recovery around stale
WDA runner/process/tunnel/device-preparation state before asking the operator
to inspect on-device Developer/UI Automation settings.
