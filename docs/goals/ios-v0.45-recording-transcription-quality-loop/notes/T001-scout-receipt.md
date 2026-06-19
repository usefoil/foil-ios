# T001 Scout Receipt

Result: done

Existing recording/transcription states:

- `AudioCaptureController` supports start and stop, microphone permission
  denial, recording start failure, saved recording state, and shared keyboard
  processing state.
- `TranscriptionController` supports missing recording, missing provider key,
  transcribing, provider failures, no-speech detection, success, and recovered
  success.
- `FoilDictationLoopPresenter` exposes record, finish recording, create
  transcript, retry transcript, and reset primary actions.
- `ContentView` exposes start, stop, transcribe, retry transcription, transcript
  review retry/reset, and reset shared state controls.

Gap against v0.45 oracle:

- The board explicitly names cancel, but the app has no first-class cancel
  recording action. Users can reset shared state, but that is broader and less
  clear while actively recording.
- Real-audio success and three insert cycles still require physical device/WDA,
  microphone permission, and provider credentials. Those must use safe phrases
  and sanitized receipts only.

Safe worker slice:

- Add a clear cancel-recording action to the presenter/UI/controller path.
- Keep cancel local: stop recording, remove the in-progress recording file when
  present, reset shared keyboard state, and return to an idle/recoverable app
  state.
- Prove the visible action and existing transcript-quality/recovery copy with
  simulator/unit tests.

Physical proof boundary:

Do not claim v0.45 complete until current-build physical receipts prove
microphone permission, start/stop/cancel, success, retry/failure, reset, and
three safe real-audio insert cycles without private audio/transcript or secret
leakage.
