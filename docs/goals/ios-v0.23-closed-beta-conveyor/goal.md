# Foil iOS v0.23 Closed Beta Rehearsal Conveyor

## Original Request

Plan each closed-beta readiness step carefully with as many GoalBuddy prep
boards as needed, using measurable acceptance criteria at every task.

## Outcome

Coordinate a physical iPhone closed-beta rehearsal across the Apple app baseline.
A trusted tester path is considered ready only after the preview iPhone proves:

1. Device, WDA, signing, TestFlight, provider, and keyboard preflight are known.
2. The current TestFlight build installs or updates cleanly.
3. Foil records and transcribes a sterile phrase on the installed build.
4. Foil Keyboard inserts the latest transcript in Notes, Messages/iMessage,
   Mail, and Safari/text fields, with secure/private fields handled honestly.
5. One realistic recovery/reset path is proven.
6. Any small beta UX fixes discovered by testing are either merged and proven or
   recorded as explicit beta-blocking follow-ups.

## Oracle

This conveyor is complete only when every child board has a receipt-backed
completion state and the final readiness audit rules out the strongest realistic
failure mode: we think the app is beta-ready because one happy-path smoke passed,
but a real tester cannot install, enable, dictate, insert, or recover in the
Apple app baseline without hand-holding.

## Conveyor Boards

1. `docs/goals/ios-v0.23-beta-preflight/goal.md`
2. `docs/goals/ios-v0.23-testflight-rehearsal/goal.md`
3. `docs/goals/ios-v0.23-apple-app-matrix/goal.md`
4. `docs/goals/ios-v0.23-beta-recovery-ux/goal.md`
5. `docs/goals/ios-v0.23-readiness-audit/goal.md`

## Constraints

- Put this work in the standalone `foil-ios` repo.
- Allow small beta UX fixes only when physical rehearsal evidence shows they
  remove tester friction or prevent false confidence.
- Do not add broad new product features.
- Do not expand into third-party apps in this conveyor.
- Do not commit credentials, raw WDA trees from private screens, raw private
  message content, Groq keys, App Store Connect keys, or unsanitized transcripts.
- Device unlock, install replacement prompts, private app content, credentials,
  destructive cleanup, and true external blockers require the operator.
- PRs should be small and merged only after checks pass.

## Starter Command

`/goal Follow docs/goals/ios-v0.23-closed-beta-conveyor/goal.md.`
