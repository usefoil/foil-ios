# T003 Judge Audit - Simulator Sanity Regression

Date: 2026-06-09

## Claim

The simulator sanity lane is useful and scoped correctly.

## Strongest realistic failure mode

A future board treats a passing simulator lane as proof that Foil Keyboard works
inside Safari, Notes, Messages, Reminders, Mail, or secure fields on the
physical preview iPhone.

## Evidence

- `scripts/ios-simulator-sanity.sh` prints:
  `this does not prove physical keyboard insertion or host-app behavior`.
- `docs/ios-simulator-sanity-runbook.md` lists the non-physical proof boundary
  and points physical claims to `scripts/ios-physical-harness.py preflight
  --strict` plus host-app matrix receipts.
- `scripts/ios-simulator-sanity.sh` passed.

## Decision

Pass. The lane catches deterministic app, keyboard extension, shared state,
provider, and keyboard-state regressions without claiming physical host-app
behavior.
