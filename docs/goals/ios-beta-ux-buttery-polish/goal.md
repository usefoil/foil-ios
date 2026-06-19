# Foil iOS Beta UX Buttery Polish

## Goal

Make the current Foil iOS beta path feel clear, calm, and hard to misuse for a first-time iPhone tester, without loosening any existing safety gates around route readiness, Full Access, keyboard health, App Group state, provider setup, secure fields, exact-once insertion, or privacy.

The desired beta journey is:

1. The tester immediately understands that the current usable beta path is **Use an API key on this iPhone**.
2. **Use my Mac** remains visible as the future/recommended product direction, but never feels like the path testers should complete today.
3. The app explains Full Access plainly and narrowly before the tester sees Apple’s broad warning.
4. Recording, transcription, return-to-target-app, keyboard switch, and Insert latest feel like one guided loop.
5. Disabled, stale, provider-error, App Group, and processing states tell the tester exactly what to do next.
6. Safe/tested host-app boundaries are visible at the right moment, not buried behind diagnostics.
7. Docs and feedback templates match the current beta build and do not contradict the app.

## Non-Goals

- Do not implement real Mac bridge pairing in this goal.
- Do not broaden host-app support claims beyond proven Safari, blank Notes, Messages draft-only, and secure-field rejection.
- Do not weaken exact-once insertion, stale-state rejection, Full Access, keyboard-health, App Group, or provider-route gates.
- Do not expose provider keys, transcripts, private phone content, raw WDA trees, screenshots, recordings, archives, IPAs, App Store Connect keys, or JWTs.
- Do not commit physical-device raw artifacts. Commit only sanitized receipts.

## Primary UX Risks To Eliminate

1. Current beta path is usable, but first-run selection still points at a future Mac route.
2. A saved provider key can be mistaken for a verified provider route.
3. The record-in-Foil then return-to-target-app loop can feel broken even when exact-once insertion works.
4. Keyboard disabled/stale/error states are safe but too terse.
5. Provider failure recovery and aged processing states can feel like dead ends.
6. Safe-target and privacy boundaries are buried under Advanced / Support.
7. Tester docs have build-claim drift.

## Acceptance Criteria

- Fresh first-run state visibly foregrounds the current beta path without hiding the future Mac path.
- Mac and Advanced routes still cannot produce setup-complete.
- API-key setup copy distinguishes key-saved from provider-verified unless live verification has actually succeeded.
- Ready-to-insert app state visibly guides: return to the target field, switch to Foil Keyboard, tap Insert latest once.
- Keyboard states use specific labels for idle, Full Access off, stale, failed, processing, complete, and inserted-once states.
- Provider-key failure recovery surfaces key update as the primary repair when appropriate and never leaks key material.
- Aged processing or stale non-complete states offer clear retry/reset recovery while remaining non-insertable.
- Tested target guidance is visible outside Advanced at ready/recovery moments.
- README, beta handoff docs, and feedback issue template agree on current beta build claims or mark historical builds clearly.
- Focused tests cover the presentation and bridge behavior changed by each slice.
- Strongest realistic proof includes simulator tests plus, when possible, a sanitized physical walkthrough on iPhone-preview.

## Burden Of Proof

Before declaring the goal complete, disprove the main failure mode:

> The app looks ready or smooth while a real tester would still be blocked by the wrong route, unverified provider key, Full Access, stale keyboard health, App Group state, unsupported host app, secure field, stale transcript, stuck processing, or failed insertion.

Use:

- Focused `FoilDictationLoopPresentationTests`, `FoilProviderFailurePresentationTests`, and `FoilKeyboardBridgeTests`.
- `git diff --check`.
- `node /Users/neonwatty/.codex/plugins/cache/goalbuddy/goalbuddy/0.3.8/skills/goalbuddy/scripts/check-goal-state.mjs docs/goals/ios-beta-ux-buttery-polish/state.yaml`.
- Privacy/no-overclaim scans over changed files and receipts.
- Simulator UI checks if they can inspect the changed visible states.
- Physical iPhone receipts only when the preview device is available and the host surface is sterile.

## Suggested Starter

Run:

```text
/goal Follow docs/goals/ios-beta-ux-buttery-polish/goal.md.
```

