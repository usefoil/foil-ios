# T007 Timeout Fix And Processing Blocker Receipt

Claim: the manual safe-phrase pass moved the physical App Group out of idle, but the current PR #30 build left the bridge in a stale `processing` state instead of reaching complete, failed, or retryable UI.

Strongest realistic failure mode: a tester records and taps Transcribe, then onboarding/insertion stays blocked forever because the provider upload never returns and the keyboard bridge remains `processing`.

Evidence:
- `notes/physical/T007-preflight-healthy.json` proves WDA was healthy before reading Foil or host-app state.
- `notes/physical/T007-app-group-before-transcribe.json` proves the manual phone-side pass had moved the App Group to `processing` with no transcript.
- `notes/physical/T007-app-group-final-processing.json` proves the same `processing` snapshot persisted through the bounded poll window, still with no transcript.
- `notes/physical/T007-processing-stuck-ui.json` proves the Foil UI did not expose the sterile phrase, retry, or transcript-review state while the App Group was stuck.
- `FoiliOS/FoilIOSApp/FoilTranscriptionClient.swift` now sets an explicit provider upload timeout so future transcription attempts use the existing recoverable timeout path instead of waiting indefinitely.
- `FoiliOS/FoilIOSTests/FoilTranscriptionClientTests.swift` covers the default timeout and injected timeout value.
- `notes/physical/T007-install-timeout-fix.json`, `notes/physical/T007-app-group-reset-after-timeout-fix.json`, and `notes/physical/T007-timeout-fix-idle-ui.json` prove the timeout-fix build installed, reset stale state back to idle, and returned to an idle recording surface.

Current blocker: the post-fix live success proof is still missing. After the timeout-fix build was installed and reset to idle, WDA watched for a phone-side Record/Stop transition but the UI stayed idle for the full watch window.

Residual risk / follow-up: rerun the physical safe-phrase pass on the timeout-fix build. If the provider returns, collect Transcribe and sterile Insert Latest receipts. If it times out, collect the failed/retry receipt and verify the App Group is no longer stranded in `processing`.
