# T003 Final Closed Beta Readiness Recommendation

Date: 2026-06-12T02:26Z
Recommendation: `invite_narrow_internal_build13_only`

## Scope Allowed

Foil iOS may continue with narrow internal feedback against TestFlight build `0.1.0 (13)` for the app-to-keyboard dictation loop, with tester instructions constrained to:

- setup/onboarding and Full Access enablement;
- provider configuration and recovery messaging;
- sterile Safari normal text-field insertion;
- Safari secure/password field rejection;
- carefully prepared blank Notes or fake/dedicated Messages draft surfaces only as feedback targets, not as proven build 13 pass claims.

## Scope Not Allowed Yet

Do not invite broader closed beta testers or describe the iOS preview as generally ready until these blockers are closed:

- PR #27: first-run onboarding polish remains draft/open.
- PR #29: keyboard setup and Full Access recovery remains draft/open.
- PR #30: recording/transcription quality loop remains draft/open.
- PR #31: Insert Latest freshness/exact-once polish remains draft/open.
- PR #46 and PR #47: GoalBuddy ledger metadata fixes are open and mergeable, but still had CodeQL swift in progress at the audit rerun.
- v0.47/v0.48: additional current-build host-app matrix expansion is blocked right now because `scripts/ios-physical-harness.py preflight --strict --wda-url http://192.168.1.40:8100` fails closed with `classification: wda_unreachable`.

## Strongest Realistic Failure Mode

Failure mode: we accidentally treat the successful build 13 TestFlight path, docs, simulator tests, or stored physical receipts as enough proof for a broad closed beta and ship copy that implies arbitrary iPhone app support or current WDA health.

Evidence ruling this down:

- The child-board ledger maps every v0.42-v0.52 board to either a merged PR, explicit accepted blocker, or superseding TestFlight physical-gate receipt.
- Simulator sanity is labeled non-physical and does not claim host-app insertion proof.
- Build 13 TestFlight evidence comes from `docs/goals/ios-testflight-readiness-physical-gate/state.yaml`, which validates as done and records validation, upload, App Store Connect processing/internal group state, TestFlight install/open flow, keyboard-health recovery, and idle/no-transcript App Group state without committing secrets or raw private artifacts.
- The same rerun proved current WDA is not healthy for fresh host-app expansion: `scripts/ios-physical-harness.py preflight --strict --wda-url http://192.168.1.40:8100` exited non-zero with `classification: wda_unreachable`, `safeToTouchHostApps: false`, device state `available (paired)`, and privacy booleans showing no host apps, raw WDA source, screenshots, or transcript bodies touched.
- iOS repo copy scan preserves build 13 scope and named unsupported claims.
- Public Foil copy was tightened in usefoil/foil#288 and post-merge scans show build-scoped language.

## Final Decision

The closed-beta polish conveyor is complete as an audit conveyor, not as a broad-launch conveyor. The safest next product posture is `invite_narrow_internal_build13_only`: keep build 13 internal feedback moving with strict private-content guardrails, then resume broader beta work after the draft UX PRs, GoalBuddy ledger PRs, and fresh physical host-app matrix proof are complete.
