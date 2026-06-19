# T006 Physical Recording Cancel Receipt

Claim: after WDA recovered, the current PR #30 build can prove setup-ready recording controls and the physical cancel path, but live transcription remains blocked by the audible speech capture environment.

Strongest realistic failure mode: the app or PR says the live recording loop is ready because the UI controls exist, while physical setup, keyboard health, microphone, provider route, App Group state, or the actual recording/transcription path still fails.

Evidence:
- `notes/physical/T006-preflight-healthy.json` proves WDA was healthy on the direct device URL before host-app work.
- `notes/physical/T006-install-current-build.json` records sanitized current-build metadata for the PR #30 Debug install; raw install URLs were not committed.
- `notes/physical/T006-current-recording-surface.json` proves the current build exposed recording controls before keyboard refresh, but correctly kept `onboarding-not-ready` present while keyboard health was stale.
- `notes/physical/T006-safari-fixture-loaded.json` proves the sterile Safari fixture loaded and the safe phrase count was zero before field focus.
- `notes/physical/T006-safari-normal-focused-keyboard.json` proves the sterile normal field surfaced Foil Keyboard with Full Access on and Insert Latest disabled for idle/no-transcript state.
- `notes/physical/T006-onboarding-ready-recording-surface.json` proves Foil returned to setup-ready after keyboard check-in: `onboarding-ready` present, stale keyboard warning absent, `Foil Keyboard checked in` present, and recording controls in sane idle state.
- `notes/physical/T006-recording-active-cancel-available.json` proves a physical recording start enables Stop and Cancel while keeping Transcribe disabled.
- `notes/physical/T006-recording-cancel-returned-idle.json` and `notes/physical/T006-app-group-after-cancel.json` prove Cancel returns the app and App Group to idle/no transcript.
- `notes/physical/T006-live-recording-stopped-transcribe-ready.json` proves a sterile live recording can be started and stopped, making Transcribe available.
- `notes/physical/T006-live-transcription-result.json`, `notes/physical/T006-live-transcription-retry-result.json`, and their App Group summaries prove two live sterile TTS attempts reached Transcribe but ended in `No speech detected`, App Group `phase=failed`, `hasTranscript=false`.

Current blocker: live transcription and insert-cycle receipts need an audible sterile phrase captured by the iPhone microphone. The Mac TTS attempts were not detected by the phone in this environment.

Residual risk / follow-up: live transcription success, retry/reset after successful transcription, and three consecutive safe real-audio record -> transcribe -> Insert Latest cycles remain unproven. The next run should have the operator speak `Foil safe test phrase June twelve` near the iPhone while recording, then continue to the sterile Safari Insert Latest cycle if transcription succeeds.
