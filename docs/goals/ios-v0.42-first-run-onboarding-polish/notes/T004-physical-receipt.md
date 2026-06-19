# T004 Physical Receipt

Superseded: this partial no-overclaim receipt remains useful history, but the
missing setup-complete receipt was later collected in T006 before PR #27 merged.

Claim: First-run route choice is visible and does not call setup complete until the route, microphone, keyboard health, Full Access, and App Group gates are all satisfied.

Strongest realistic failure mode: the onboarding UI says setup is complete because one route/provider path looks configured, while physical keyboard health, Full Access, microphone permission, or App Group state still blocks insertion.

Evidence:
- `notes/physical/T004-preflight.json` proves the physical device and WDA were healthy before host-app checks.
- `notes/physical/T004-install.json` proves the PR #27 development build was installed on iPhone-preview.
- `notes/physical/T004-first-run-mac-default.json` proves first-run route choice is present with Use my Mac, Use an API key on this iPhone, Advanced, and a visible API-route CTA while onboarding remains not ready.
- `notes/physical/T004-api-route-not-ready.json` proves the API-key route is selectable and provider/keyboard recovery setup remains usable, but onboarding still refuses setup-complete.
- `notes/physical/T004-advanced-collapsed.json` proves fake transcript, reset, secure-field, and diagnostic tools are not exposed while Advanced / Support is collapsed.
- `notes/physical/T004-keyboard-health-checkin.json` proves Foil Keyboard was opened in the sterile Safari fixture during the run.
- `notes/physical/T004-after-keyboard-health-not-ready.json` and `notes/physical/T004-after-app-reset-not-ready.json` prove the app still exposes `onboarding-not-ready` and forbids `onboarding-ready` after the keyboard-health attempt and app reset attempt.
- `notes/physical/T004-app-group-after-health.json` proves the App Group snapshot was idle/no transcript during the not-ready receipt.

Current physical blocker: iPhone-preview still reports onboarding blockers for microphone permission, keyboard Full Access/health verification, and app-visible shared-state reset. This branch should stay blocked until those gates are satisfied and a separate receipt proves `onboarding-ready`.

Residual risk / follow-up: setup-complete was not proven on this branch in this pass. The useful proof collected here is the overclaim boundary: the UI does not say ready while the physical gates remain unmet. Raw WDA trees stayed in `/tmp`; committed receipts contain identifiers, hashes, counts, and pass/fail assertions only.
