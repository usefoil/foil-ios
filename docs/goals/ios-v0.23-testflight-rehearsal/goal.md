# Foil iOS v0.23 TestFlight Rehearsal

## Outcome

Prove the current closed-beta TestFlight build can be installed or updated on
the preview iPhone and can produce a fresh sterile transcript ready for keyboard
insertion.

## Oracle

This board is complete only when device metadata proves the installed build,
Foil records/transcribes a sterile phrase on that installed build, and App Group
state proves a latest transcript is staged for the keyboard without leaking
private content.

## Non-Goals

- Do not upload a new build unless the Judge approves a fix-required release
  slice.
- Do not use debug-installed builds as TestFlight proof.
- Do not run the Apple host-app matrix here; hand off a staged transcript to the
  matrix board.

## Starter Command

`/goal Follow docs/goals/ios-v0.23-testflight-rehearsal/goal.md.`
