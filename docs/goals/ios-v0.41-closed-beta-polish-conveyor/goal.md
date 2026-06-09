# Foil iOS v0.41 Closed Beta Polish Conveyor

## Outcome

Polish Foil iOS from the current build-12 narrow internal preview into a
closed-beta-ready iPhone experience, with end-to-end proof for onboarding,
configuration, keyboard setup, recording/transcription, Insert Latest usage,
safe host-app behavior, tester feedback, TestFlight launch rehearsal, and final
readiness.

## Oracle

This conveyor is complete when every child board has either merged its clean
slice with receipts or recorded an exact blocker with owner/action, and the
final readiness audit can recommend one of:

- `invite_closed_beta`
- `invite_narrow_internal_only`
- `hold_for_named_blockers`

The audit must be backed by physical iPhone evidence, simulator sanity checks,
copy/overclaim scans, TestFlight state, and tester-facing setup/usage proof. No
board may claim broad iPhone app support, Mail support, Messages delivery,
existing private-thread safety, secure-field support, or public App Store
availability unless that exact behavior has been proven in receipts.

## Conveyor Boards

1. `ios-v0.42-first-run-onboarding-polish`
2. `ios-v0.43-provider-configuration-health`
3. `ios-v0.44-keyboard-setup-full-access-recovery`
4. `ios-v0.45-recording-transcription-quality-loop`
5. `ios-v0.46-insert-latest-usage-ux`
6. `ios-v0.47-host-app-sterile-matrix-expansion`
7. `ios-v0.48-physical-automation-hardening`
8. `ios-v0.49-beta-feedback-intake-loop`
9. `ios-v0.50-simulator-sanity-regression`
10. `ios-v0.51-evidence-hygiene-audit`
11. `ios-v0.52-testflight-beta-launch-rehearsal`
12. `ios-v0.53-closed-beta-final-readiness-audit`

## Autonomous Execution Rules

- Work one active task at a time inside this parent board.
- For each child board, create a branch, implement the smallest coherent slice,
  verify against that board oracle, open a PR, monitor CI, fix conflicts or
  failures, merge when green, fast-forward local `main`, then continue.
- Use physical iPhone proof whenever the behavior involves keyboard extension,
  TestFlight install/update, Settings, host apps, paste/insert, microphone, or
  tester onboarding.
- Use simulator proof for fast regression sanity and UI snapshot coverage, but
  do not substitute simulator-only proof for keyboard-extension behavior that
  depends on iOS host-app integration.
- Keep raw WDA sources, screenshots, movies, private transcripts, phone numbers,
  contacts, account names, and message/email contents out of committed receipts.
- Stop only for credentials, private content, destructive actions, device
  unlock/install actions, Apple account state, or a true external blocker.

## Starter Command

`/goal Follow docs/goals/ios-v0.41-closed-beta-polish-conveyor/goal.md.`
