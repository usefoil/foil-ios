# T003 Final Closed Beta Readiness Recommendation

Date: 2026-06-09
Recommendation: `invite_narrow_internal_only`

## Scope Allowed

Foil iOS may continue with narrow internal feedback against TestFlight build `0.1.0 (12)` for the app-to-keyboard dictation loop, with tester instructions constrained to:

- setup/onboarding and Full Access enablement;
- provider configuration and recovery messaging;
- sterile Safari normal text-field insertion;
- Safari secure/password field rejection;
- carefully prepared blank Notes or fake/dedicated Messages draft surfaces only as feedback targets, not as proven build 12 pass claims.

## Scope Not Allowed Yet

Do not invite broader closed beta testers or describe the iOS preview as generally ready until these blockers are closed:

- PR #27: first-run onboarding polish remains draft/open.
- PR #29: keyboard setup and Full Access recovery remains draft/open.
- PR #30: recording/transcription quality loop remains draft/open.
- PR #31: Insert Latest freshness/exact-once polish remains draft/open.
- v0.47/v0.48: healthy physical automation and current-build host-app matrix reruns remain blocked by WDA/physical automation health.
- v0.52: build `0.1.0 (13)` is archive/export-ready only; upload, TestFlight availability, preview-iPhone install/update, and post-update smoke are blocked on App Store Connect auth inputs and physical automation health.

## Strongest Realistic Failure Mode

Failure mode: we accidentally treat docs, simulator tests, or local build 13 export as enough proof for a broad closed beta and ship copy that implies arbitrary iPhone app support.

Evidence ruling this down:

- The child-board ledger maps every v0.42-v0.52 board to either a merged PR or explicit accepted blocker.
- Simulator sanity is labeled non-physical and does not claim host-app insertion proof.
- Build 13 evidence is limited to local archive/export metadata, icon, and signing proof; no upload, install, or physical smoke is claimed.
- iOS repo copy scan preserves build 12 scope and named unsupported claims.
- Public Foil copy was tightened in mean-weasel/foil#288 and post-merge scans show build-scoped language.

## Final Decision

The closed-beta polish conveyor is complete as an audit conveyor, not as a broad-launch conveyor. The safest next product posture is `invite_narrow_internal_only`: keep build 12 internal feedback moving with strict private-content guardrails, then resume broader beta work after the draft UX PRs, build 13 TestFlight upload, and physical host-app smoke are complete.
