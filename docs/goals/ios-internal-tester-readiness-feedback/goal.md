# Foil iOS Internal Tester Readiness And Feedback

## Outcome

Turn the green build `0.1.0 (13)` TestFlight release gate into a tester-ready
handoff and feedback triage path.

The board should make it safe for internal testers to use the current beta
without overstating Mac pairing, broad host-app support, or privacy claims.

## Oracle

The board is complete only when:

- tester-facing handoff docs name build `0.1.0 (13)`;
- setup instructions explain the three route choices and make API-key-on-iPhone
  the usable current beta path;
- Full Access copy is narrow and tied to Foil's shared transcript state;
- keyboard health verification and recovery are explicit;
- feedback triage asks only for safe, non-private evidence;
- the final audit maps every claim to the build-13 release gate or a named
  residual risk.

## Acceptance Criteria

- Do not claim Mac pairing works until it is implemented and proved.
- Do not claim arbitrary app support, Mail support, Messages delivery, or safe
  use inside existing private threads.
- Do not ask testers for private transcript text, provider keys, screenshots of
  private phone content, account identifiers, or credentials.
- Treat stale keyboard health as a first-class setup state, not a tester error.
- Keep TestFlight/build-13 claims tied to the sanitized release-gate receipts in
  `docs/goals/ios-testflight-readiness-physical-gate`.

## Starter Command

`/goal Follow docs/goals/ios-internal-tester-readiness-feedback/goal.md.`
