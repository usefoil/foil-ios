# Foil iOS v0.23 Beta Preflight

## Original Request

Prepare the first closed-beta rehearsal board carefully, with measurable
acceptance criteria.

## Outcome

Before spending time on app-matrix testing, prove the preview iPhone and local
automation surface are in a known-good state for closed-beta rehearsal.

## Oracle

This board is complete only when device reachability, WDA, installed Foil build,
TestFlight state, provider/key presence, microphone permission, app-group state,
and keyboard/full-access state are each either proven with sanitized receipts or
blocked with a precise operator action.

## Non-Goals

- Do not change product code.
- Do not install or replace apps unless the TestFlight rehearsal board approves
  that step.
- Do not print credentials or raw private device content.

## Starter Command

`/goal Follow docs/goals/ios-v0.23-beta-preflight/goal.md.`
