# T001 Preflight Scout

## Claim

The preview iPhone is reachable and enough safe state can be inspected to decide
whether the v0.23 closed-beta rehearsal may proceed.

## Evidence Gathered

- Device details receipt shows `iPhone-preview` is a physical iPhone 11 on iOS
  26.5 with Developer Mode enabled, paired, and tunnel connected.
- Harness status receipt shows the device is present and `iproxy` plus the WDA
  project are available.
- Installed-app receipt shows `com.neonwatty.FoilIOS` version `0.1.0`, bundle
  version `11`.
- App Group summary shows `phase=idle` and `hasTranscript=false`.
- App Group preferences show keyboard health `fullAccessState=enabled`,
  snapshot `idle`, no transcript, and canonical storage verification succeeded.
- Process receipt shows Foil iOS, Foil Keyboard, TestFlight, and SpringBoard were
  present in the process list during preflight.
- WDA was attempted twice. Both xcodebuild runs reached the phone and failed
  with `Timed out while enabling automation mode`; the retry with an explicit
  `iproxy -n` tunnel also reported no matching network device for the tunnel.

## Unknowns

- Current provider/key presence could not be verified directly. The key is stored
  in the app keychain and is intentionally not present in App Group state.
- Current microphone permission could not be verified directly without app UI
  automation or performing a live command-mailbox recording, which would mutate
  device/App Group state beyond this Scout task.

## Recommendation

`operator_needed`: do not proceed to the TestFlight rehearsal or Apple app matrix
until WDA/physical UI automation is restored, or until the board is explicitly
changed to approve a command-mailbox rehearsal path that mutates App Group state.

## Receipts

- `notes/receipts/device-details.json`
- `notes/receipts/status-after-wda-retry.json`
- `notes/receipts/installed-app-metadata.json`
- `notes/receipts/app-group-summary.json`
- `notes/receipts/app-group-files.json`
- `notes/receipts/app-group-preferences.json`
- `notes/receipts/process-presence.json`
- `notes/receipts/wda-failure.json`
