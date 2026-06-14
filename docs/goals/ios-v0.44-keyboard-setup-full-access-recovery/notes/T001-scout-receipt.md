# T001 Scout Receipt

Result: done

Existing keyboard setup surfaces:

- The app shows a closed beta setup checklist with provider, microphone, Add
  Foil Keyboard, Allow Full Access, record, insert, and reset steps.
- Keyboard health distinguishes Full Access disabled, unverified, stale enabled,
  and fresh enabled states.
- The keyboard disables Insert latest and Clear latest when Full Access is off
  or no insertable transcript exists.
- The keyboard records Full Access health back to the shared App Group and
  deep-links back to Foil when Full Access is off.
- The handoff doc already tells testers to use Settings > General > Keyboard >
  Keyboards and to cycle/refocus when the keyboard looks stale.

Physical automation status:

- `scripts/ios-physical-harness.py status` found `iPhone-preview` present and
  looking available.
- `iproxy` is present.
- The Appium WebDriverAgent project is present.
- WDA is not reachable at `http://127.0.0.1:8100` (`URLError`).

Safe local worker slice:

- Tighten setup/recovery copy so testers know to use the globe/Next Keyboard
  control and refocus the field after enabling Full Access.
- Add unit tests for the revised setup, Full Access, unverified, and stale
  keyboard recovery copy.
- Update tester-facing handoff copy if wording changes.

Physical proof boundary:

The final v0.44 oracle still requires physical Settings/keyboard receipts. Do
not claim this child board complete or merge it as beta proof until WDA or an
equivalent physical automation path is reachable and any install/trust actions
are approved by the operator.
