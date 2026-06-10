# Foil iOS TestFlight Readiness With Physical Gate

## Outcome

Run a fresh TestFlight/readiness pass for Foil iOS after route-first onboarding
landed, using the physical iPhone proof from issue #39 as a release gate.

This board should decide whether build `0.1.0 (13)` is ready to validate,
upload, attach to internal TestFlight, and smoke on the preview phone. It should
produce sanitized receipts or exact blockers for each release step.

## Oracle

The board is complete only when a final Judge receipt proves every applicable
release gate:

- issue #39 is closed with physical evidence;
- the route-first physical-proof board validates as done;
- archive/export artifacts are regenerated from current `main`;
- IPA metadata matches the intended app and keyboard extension version/build;
- icon and bundle requirements that previously failed are inspected;
- App Store Connect validation succeeds, or the exact auth/signing blocker is
  recorded before upload;
- upload is attempted only when validation is green and the side effect is
  intended;
- uploaded build status, export compliance, internal group attachment, tester
  state, and preview-phone/TestFlight smoke are proven or exactly blocked.

## Acceptance Criteria

- The strongest false-ready mode is named for every gate.
- Receipts do not include API keys, private `.p8` contents, JWTs, provider keys,
  App Store account secrets, private phone content, raw WDA trees, screenshots
  with private content, or temporary IPA/archive artifacts.
- `/tmp` archive/export artifacts are treated as ephemeral and are not committed.
- No upload occurs from stale archive/export artifacts.
- No internal/external beta state is claimed from stale App Store Connect data.
- Preview-phone smoke uses the physical route-first proof as the minimum local
  release gate and records exact blockers for TestFlight install/auth prompts.

## Starter Command

`/goal Follow docs/goals/ios-testflight-readiness-physical-gate/goal.md.`
