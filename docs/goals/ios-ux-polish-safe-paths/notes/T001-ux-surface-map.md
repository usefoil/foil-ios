# T001 UX Surface Map

Date: 2026-06-19
Result: `done`

## Surface Map

### Foil App

- Primary screen: [FoiliOS/FoilIOSApp/ContentView.swift](../../../FoiliOS/FoilIOSApp/ContentView.swift)
- The first visible work area is the dictation console. It shows the current
  loop stage, a badge, primary/secondary actions, and status rows for keyboard,
  microphone, and transcription.
- The transcript review panel appears only when a transcript exists and gives
  retry/reset options before insertion.
- Route-first onboarding follows the dictation console and contains:
  - `Use my Mac`: recommended next/future route, not usable now.
  - `Use an API key on this iPhone`: current usable beta route.
  - `Advanced, demo, and support`: support route, not setup completion.
- The iPhone API-key route exposes setup steps, current readiness, microphone,
  provider route, provider key editor, keyboard health, recovery checklist,
  shared state, readiness blockers, and reset shared state.
- Advanced / Support hides diagnostics, fake transcript staging, secure-field
  rejection, reset, safe target guidance, storage summary, transcript review
  visibility, recording filename, secure test field, and diagnostic buttons.

### Foil Keyboard

- Primary file: [FoiliOS/FoilKeyboard/KeyboardViewController.swift](../../../FoiliOS/FoilKeyboard/KeyboardViewController.swift)
- Visible controls are intentionally small:
  - status label;
  - message label;
  - Insert latest;
  - Clear latest;
  - Dictate/Open Foil;
  - Next Keyboard.
- Full Access off disables Insert latest/Clear and opens the containing app with
  a keyboard-health callback.
- Insert consumes shared transcript state once via
  `consumeTranscriptForInsertion`, then refreshes and labels the result
  `Inserted.`

### Presenter/State Contract

- Primary presenter: [FoiliOS/Shared/FoilDictationLoopPresenter.swift](../../../FoiliOS/Shared/FoilDictationLoopPresenter.swift)
- Setup readiness is blocked by missing provider key, microphone block,
  unverified/off/stale keyboard health, pending transcript, non-idle snapshot,
  or unhealthy App Group storage.
- Mac route never completes setup in this build.
- Advanced/support route never completes setup.
- Keyboard presentation rejects stale and non-complete leftover transcripts.
- Full Access copy is narrow: read/clear Foil shared transcript state.

### Existing Proof

- Parent conveyor now marks #27, #29, #30, and #31 merged:
  `docs/goals/ios-v0.41-closed-beta-polish-conveyor/state.yaml`.
- TestFlight build `0.1.0 (13)` physical gate is done:
  `docs/goals/ios-testflight-readiness-physical-gate/state.yaml`.
- The physical TestFlight gate proved failure-before-keyboard-refresh, final
  onboarding-ready after sterile Safari keyboard refresh, Full Access ready text
  by hash, and App Group idle/no transcript.
- The route-first physical proof proved API-key/provider route readiness,
  keyboard health readiness, exact-once Safari insertion, and App Group
  idle/no-transcript recovery.
- Host-app matrix:
  [docs/ios-keyboard-host-app-matrix.md](../../ios-keyboard-host-app-matrix.md)
  shows Safari as the strongest current safe row. Notes and Messages have older
  pass rows and later privacy-blocked/current-build rows; they require a fresh
  sterile precheck before any renewed claim.

## Likely Friction Points

1. **Screen order may bury first-run setup.**
   The dictation console appears before route setup. This is good for returning
   users, but first-run testers might see `Record in Foil` before realizing that
   provider, microphone, keyboard, Full Access, and App Group gates are not
   ready. The setup readiness panel mitigates this only after the route panel is
   reached.

2. **Duplicate action surfaces can split attention.**
   The dictation console has primary actions and a separate four-button grid
   (`Record`, `Stop`, `Cancel`, `Transcribe`). This is useful for diagnostics
   and receipts, but a first-run tester could wonder which control is canonical.

3. **Keyboard labels are functional but terse.**
   The keyboard communicates state, but `Clear latest` / `Inserted.` / `No
   transcript yet` may need physical review for whether they feel obvious in
   context after app switching.

4. **Notes and Messages need current sterile gating.**
   Docs allow blank Notes and fake/dedicated Messages drafts as feedback
   targets, but the latest current-build matrix has privacy blocks for those
   rows. This pass should not turn them into supported pass claims unless T002
   can prove sterile surfaces without private content.

5. **Mac route is intentionally future-facing.**
   Current presenter tests enforce that Mac pairing is not connected and cannot
   complete setup. Physical review should confirm this feels like guidance, not
   a dead-end error.

## Candidate Physical Walkthrough

Use only sanitized receipts and sterile text:

1. Strict preflight:
   `python3 scripts/ios-physical-harness.py preflight --strict --wda-url http://192.168.1.40:8100`
2. Foil app readiness on current install:
   - require route-first onboarding identifiers;
   - require iPhone API-key route visible;
   - require Mac route future/not-complete boundary;
   - require setup readiness not-ready if any gate is stale;
   - require Advanced / Support hidden unless disclosure is opened.
3. Keyboard health refresh:
   - open sterile Safari field;
   - confirm Foil Keyboard appears;
   - confirm Full Access ready/off/stale state without transcript bodies;
   - return to Foil and confirm readiness state changes only after keyboard
     check-in.
4. Safari exact-once:
   - stage or create a sterile phrase;
   - insert once;
   - assert target value count is one;
   - assert Insert latest disabled/consumed;
   - assert App Group idle/no transcript.
5. Notes blank editor:
   - attempt only if a blank editor can be proven without existing note content;
   - otherwise record a privacy blocker before staging transcript.
6. Messages fake/dedicated draft:
   - attempt only from a fake recipient or dedicated test draft with no private
     thread/list content inspected;
   - assert draft-only insertion, no send action, cleanup, and App Group idle;
   - otherwise record a privacy blocker.
7. Secure field:
   - confirm Foil Keyboard absent or insert rejected;
   - confirm transcript not consumed by secure focus;
   - cleanup App Group.

## Recommended Next Task

Advance to T002. First run strict preflight with the direct WDA URL. If WDA is
healthy, collect sanitized walkthrough receipts in this board's `notes/`
directory. If WDA is not healthy, record the exact preflight blocker and move to
Judge prioritization based on source/test/doc evidence plus the blocked
physical-gate receipt.
