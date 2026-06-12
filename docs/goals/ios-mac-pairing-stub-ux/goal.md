# Foil iOS Mac Pairing Stub UX

## Outcome

Prepare and run the next product slice for the route-first onboarding work:
make **Use my Mac** a truthful, useful, non-blocking future path while API-key
setup on iPhone remains fully usable today.

The Mac bridge can remain mocked/stubbed. This slice should not pretend pairing
works end to end; it should create a clear local UX and internal contract seam
that future Mac bridge work can fill in.

## Oracle

The board is complete only when:

- route choice keeps **Use my Mac** recommended without making setup complete
  from a stub alone;
- the Mac pairing path explains that pairing is coming soon or unavailable in
  the current build, with a clear return path to API-key setup;
- API-key-on-iPhone still completes setup when provider route, microphone,
  Full Access, keyboard health, and App Group state are healthy;
- diagnostics/demo/test paths remain behind Advanced or Support;
- focused tests prove the Mac stub does not satisfy the readiness gate by
  itself and does not regress exact-once/stale-state behavior.

## Acceptance Criteria

- Do not claim a working Mac bridge until the shared contract and bridge are
  implemented and physically proved.
- Do not break the build-13 release-gate behavior: setup must remain blocked
  when Full Access, keyboard health, provider route, App Group state, or
  insertion readiness fails.
- Preserve API-key setup as the current usable path.
- Keep copy plain and narrow around Full Access and local shared state.
- Keep any bridge mock/stub deterministic, local, and testable.

## Starter Command

`/goal Follow docs/goals/ios-mac-pairing-stub-ux/goal.md.`
