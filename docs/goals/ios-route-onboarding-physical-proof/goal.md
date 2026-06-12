# Foil iOS Route Onboarding Physical Proof

## Outcome

Close the strongest remaining risk from PR #40: route-first onboarding must not
say setup is complete while Full Access, keyboard health, provider route, App
Group state, or Insert Latest still fails.

This board should produce sanitized physical-device proof when available, or an
exact blocker with owner/action when physical proof cannot be run safely.

## Oracle

The board is complete only when a current-build receipt proves or exactly blocks
each gate:

- installed app/build identity is current enough for PR #40 behavior;
- Foil route-first onboarding is visible on device;
- API-key route readiness is either configured without leaking secrets or
  exactly blocked;
- Full Access and Foil Keyboard health are verified or exactly blocked;
- App Group state can reset to idle/no transcript;
- one sterile host-app Insert Latest row proves exact-once insertion and App
  Group cleanup, or is exactly blocked before touching private content.

Simulator screenshots or unit tests can support the board but cannot replace
physical keyboard/host-app proof.

## Acceptance Criteria

- Evidence names the strongest realistic false-complete mode for each gate.
- Receipts are sanitized: no provider keys, raw transcript bodies, private phone
  content, contacts, raw WDA trees, or recordings with non-sterile speech.
- If WDA or device automation is unavailable, the blocker is recorded before any
  private host app is touched.
- If a sterile host-app surface cannot be established, insertion is not
  attempted and App Group state is cleaned up.
- Issue #39 remains open unless current evidence proves the acceptance evidence
  requested there.

## Starter Command

`/goal Follow docs/goals/ios-route-onboarding-physical-proof/goal.md.`
