# T004 Physical Receipt

Claim: Keyboard setup recovery names the Full Access/keyboard-health blocker clearly and does not expose Insert Latest as usable while Full Access is unavailable.

Strongest realistic failure mode: the app says keyboard setup is ready, or the keyboard enables Insert Latest, even though the physical keyboard cannot read/write the shared App Group state.

Evidence:
- `notes/physical/T004-preflight.json` proves the physical device and WDA were healthy before host-app checks.
- `notes/physical/T004-install.json` proves the PR #29 development build was installed on iPhone-preview.
- `notes/physical/T004-app-recovery-not-ready.json` proves the app shows the route-first onboarding surface, recovery guidance, and `onboarding-not-ready` while forbidding `onboarding-ready`.
- `notes/physical/T004-app-recovery-copy.json` proves the improved recovery steps are present: open a safe text field, use globe/Next Keyboard to select Foil Keyboard, and return to Foil to check keyboard health again.
- `notes/physical/T004-reset-before-keyboard.json` and `notes/physical/T004-app-group-after-keyboard.json` prove the App Group snapshot was idle/no transcript during the keyboard check.
- `notes/physical/T004-keyboard-disabled.json` proves Foil Keyboard opened in the sterile Safari field and kept Insert Latest disabled.
- `notes/physical/T004-keyboard-full-access-disabled.json` proves the keyboard showed the Full Access/refocus/cycle recovery message and `Insert unavailable`.

Current physical blocker: Foil Keyboard reports Full Access unavailable on iPhone-preview, so this pass proves recovery/disabled behavior but cannot prove the enabled Full Access path. The branch should remain blocked until the device has Full Access enabled and a follow-up receipt proves enabled Insert Latest behavior after cycling/refocusing.

Residual risk / follow-up: enabled Full Access and stale-state reset success are not proven here because the physical device is still in the blocked Full Access state. Raw WDA trees stayed in `/tmp`; committed receipts contain identifiers, hashes, counts, and pass/fail assertions only.
