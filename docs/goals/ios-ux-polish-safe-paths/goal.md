# Foil iOS UX Polish Safe Paths

## Original Request

Before starting the Mac bridge conveyor, thoroughly review the iOS UX and polish
the experience across Foil, Foil Keyboard, and common iOS host apps. Use the
audit-then-polish-safe-paths posture: inspect real use, fix high-confidence
issues, and keep host-app claims tied to sanitized proof.

## Outcome

Foil iOS should feel intuitive and trustworthy for the current beta path:

- route choice is obvious;
- API-key setup remains usable;
- Full Access and keyboard health states are plain and narrow;
- recording, transcription, insertion, stale-state recovery, and reset behavior
  are understandable;
- safe host-app use is polished in the places we can prove;
- blocked or unproven contexts do not look like supported success paths.

## Oracle

The tranche is complete when a final audit maps every polish claim to current
receipts: focused tests, code review, sanitized physical iPhone walkthrough
receipts, host-app matrix notes, and PR/CI/merge evidence. The audit must try to
disprove the main failure mode: the UX says or implies success while Full
Access, keyboard health, provider route, App Group state, insertion, or host-app
targeting still fails.

## Scope

In scope:

- Foil iOS onboarding, route choice, setup, recording, provider health, and
  recovery surfaces.
- Foil Keyboard visible states, insertion controls, stale transcript recovery,
  disabled states, and exact-once insertion messaging.
- Safe host-app walkthroughs on iPhone-preview where privacy boundaries allow
  it: Safari sterile text field, Notes blank editor, Messages fake/dedicated
  draft, and any other operator-prepared sterile text surface.
- PR creation, CI monitoring, merge when green and clean, and board receipts.

Out of scope for this tranche:

- Mac bridge implementation.
- Broad arbitrary-app support claims.
- Private Messages threads, contacts, inboxes, Mail accounts, screenshots of
  private content, raw WDA accessibility trees from private apps, recordings
  with non-sterile speech, provider keys, App Store Connect keys, JWTs,
  archives, and IPAs.
- Shipping broad beta copy beyond what this pass proves.

## Constraints

- Preserve `AGENTS.md` privacy boundaries.
- Use sanitized physical receipts only: hashes, counts, boolean identifier
  presence, build metadata, App Group phase, and pass/fail assertions.
- Treat happy-path tests, worker claims, and optimistic UI as claims until
  verified.
- Keep API-key-on-iPhone fully usable while Mac pairing remains future-facing.
- Keep exact-once insertion and stale-state recovery behavior intact.

## Likely Misfire

The dangerous failure is a beautiful UX pass that merely makes unsupported
states look supported. The board must reject any change that turns Notes,
Messages, Mail, secure fields, stale keyboard health, missing Full Access, or
missing provider route into a success claim without proof.

## Starter Command

`/goal Follow docs/goals/ios-ux-polish-safe-paths/goal.md.`
