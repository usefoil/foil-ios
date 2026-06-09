# Foil iOS v0.45 Recording And Transcription Quality Loop

## Outcome

Polish the recording/transcription loop so closed beta testers can confidently
record, stop, cancel, retry, recover from errors, and understand transcript
readiness before returning to the keyboard.

## Oracle

This board is complete when safe-phrase receipts prove microphone permission,
record start/stop/cancel, transcription success, retry, timeout/error, reset,
keyboard-shared-state readiness, and three consecutive real-audio record ->
transcribe -> Insert Latest -> App Group idle cycles on the current TestFlight
or candidate build, without exposing private speech or secrets.

## Starter Command

`/goal Follow docs/goals/ios-v0.45-recording-transcription-quality-loop/goal.md.`
