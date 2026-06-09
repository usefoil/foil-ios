# Foil iOS v0.50 Simulator Sanity Regression

## Outcome

Add a fast simulator sanity lane for closed-beta polish so app, extension,
onboarding, provider, and keyboard-state regressions are caught before slower
physical iPhone work.

## Oracle

This board is complete when simulator build/test receipts cover app and keyboard
compile health plus representative onboarding, provider, no-transcript,
transcript-ready, after-insert, stale, and reset states. Simulator receipts must
be labeled non-physical and must not be used to claim host-app keyboard behavior.

## Starter Command

`/goal Follow docs/goals/ios-v0.50-simulator-sanity-regression/goal.md.`
