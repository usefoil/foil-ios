# T004 Physical Receipt

Claim: The recording loop exposes a first-class cancel path, but live audio/cancel/transcription proof must not be claimed until microphone, provider, keyboard, and App Group gates are physically ready.

Strongest realistic failure mode: the app surfaces cancel UI in tests, but on the physical phone recording starts from a bad setup state or the PR claims live cancel/transcription success without safe microphone/provider proof.

Evidence:
- `notes/physical/T004-preflight.json` proves the physical device and WDA were healthy before app checks.
- `notes/physical/T004-install.json` proves the PR #30 development build was installed on iPhone-preview.
- `notes/physical/T004-recording-surface.json` proves the physical app exposes `start-recording-button`, `stop-recording-button`, `cancel-recording-button`, and `transcribe-latest-button`; start is enabled, while stop/cancel/transcribe are disabled before recording.
- `notes/physical/T004-physical-blockers.json` proves the current physical device still reports blockers for microphone access, keyboard Full Access/health verification, and app-visible shared-state reset.
- `notes/physical/T004-app-group-initial.json` proves the App Group snapshot was idle/no transcript during this blocked recording receipt.

Current physical blocker: live microphone/cancel/transcription proof needs explicit safe-phrase approval and a device state where microphone, keyboard Full Access/health, provider, and App Group reset gates pass. This pass intentionally did not approve microphone capture or record audio.

Residual risk / follow-up: cancel-during-active-recording, transcription retry/failure, and three safe real-audio insert cycles remain unproven physically. Raw WDA trees stayed in `/tmp`; committed receipts contain identifiers, hashes, counts, and pass/fail assertions only.
