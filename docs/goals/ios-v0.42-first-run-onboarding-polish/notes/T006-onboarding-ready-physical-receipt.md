# T006 Onboarding Ready Physical Receipt

Claim: after WDA recovered, the current PR #27 build now has physical proof for route-first setup reaching onboarding-ready only after route, microphone, keyboard health, Full Access, and app-visible App Group reset gates pass.

Strongest realistic failure mode: onboarding says setup is complete while route choice, microphone, keyboard health, Full Access, or App Group state still blocks recording/insertion.

Evidence:
- `notes/physical/T006-preflight-healthy.json` proves WDA was healthy on the direct device URL before host-app work.
- `notes/physical/T006-install-current-build.json` records sanitized current-build metadata for the PR #27 Debug install; raw install URLs were not committed.
- `notes/physical/T006-onboarding-ready-initial.json` proves the current build did not overclaim ready immediately after install: route choices were present, but `onboarding-not-ready` remained while keyboard health was stale.
- `notes/physical/T006-reset-before-ready.json` and `notes/physical/T006-app-group-after-reset.json` prove the shared App Group was reset to idle/no transcript before readiness recovery.
- `notes/physical/T006-safari-fixture-loaded.json` proves the sterile Safari fixture loaded and the safe phrase count was zero before field focus.
- `notes/physical/T006-safari-normal-focused-keyboard.json` proves the first field focus did not falsely report Foil Keyboard before keyboard cycling.
- `notes/physical/T006-safari-foil-keyboard-after-cycle.json` proves the sterile field surfaced Foil Keyboard after cycling keyboards, with Full Access warning absent and Insert Latest disabled for idle/no-transcript state.
- `notes/physical/T006-onboarding-ready-after-keyboard-refresh.json` proves keyboard health and Full Access were ready, while app-visible reset still blocked setup-complete.
- `notes/physical/T006-onboarding-ready-after-app-reset.json` and `notes/physical/T006-app-group-after-app-reset.json` prove the app-owned reset cleared the last gate: route choices remain visible, `onboarding-ready` is present, `onboarding-not-ready` is absent, keyboard checked in, Full Access is ready, stale/reset warnings are absent, and App Group is idle/no transcript.

Current blocker: none for PR #27's onboarding-ready physical receipt. This does not prove live transcription or full insert-cycle behavior; those remain on PR #30 / downstream boards.

Residual risk / follow-up: the sterile Safari flow was used only to refresh keyboard health and prove no-overclaim boundaries for onboarding. Live recording/transcription/insertion still needs the PR #30 safe-phrase pass where the operator speaks near iPhone-preview.
