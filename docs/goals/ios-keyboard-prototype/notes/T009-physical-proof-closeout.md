# T009 Physical Proof Closeout

## Result

Done.

## Summary

The parent overnight prototype queue originally stopped because the preview
iPhone was unavailable. That blocker has since been burned down by the later
GoalBuddy conveyor: the standalone iOS repo now contains physical-device
receipts proving install, real recording/transcription, Foil Keyboard
enablement, host-app insertion, and cleanup on `iPhone-preview`.

## Evidence

- `docs/goals/ios-v0.22-testflight-release-proof/notes/receipts/build11-installed-metadata.json`
  proves `iPhone-preview` has `com.neonwatty.FoilIOS` version `0.1.0`, bundle
  version `11`.
- `docs/goals/ios-v0.22-testflight-release-proof/notes/receipts/build11-foil-before-record.json`
  proves the build 11 app had `Groq key configured` and the recording control
  available.
- `docs/goals/ios-v0.22-testflight-release-proof/notes/receipts/build11-foil-after-record-start.json`
  and `build11-foil-after-record-stop.json` prove the physical app moved through
  recording and saved-recording states.
- `docs/goals/ios-v0.22-testflight-release-proof/notes/receipts/build11-foil-after-transcribe.json`
  and `build11-app-group-after-transcribe.json` prove provider transcription
  completed and produced a complete App Group transcript with hash/length only.
- `docs/goals/ios-v0.22-testflight-release-proof/notes/receipts/build11-notes-before-insert.json`
  proves Foil Keyboard was active in Notes and `Insert latest` was enabled.
- `docs/goals/ios-v0.22-testflight-release-proof/notes/receipts/build11-notes-after-insert.json`
  proves insertion happened by sterile phrase count delta and `Insert latest`
  became disabled.
- `docs/goals/ios-v0.22-testflight-release-proof/notes/receipts/build11-app-group-after-insert.json`
  and `build11-app-group-cleanup.json` prove the App Group returned to
  `phase=idle`, `hasTranscript=false`.

## Strongest Realistic Failure Mode

The parent board could be marked complete by relying on old simulator-only
evidence while physical iPhone lifecycle, microphone, provider, or keyboard
behavior still failed.

## Evidence That Rules It Out

The v0.22 board was run on the physical `iPhone-preview` after a TestFlight
install/update to build `11`, and its final audit directly rules out stale build,
debug build, and stale App Group state. The proof path includes device metadata,
WDA receipts, App Group readbacks, and a final cleanup receipt.

## Residual Risk

The physical smoke proves the core Notes flow. Broader host-app compatibility is
tracked separately in `docs/ios-keyboard-host-app-matrix.md`.
