# Foil iOS CI Reliability Observability

## Objective

Make the hosted simulator sanity lane more diagnosable after the PR #62 timeout, without changing the honest proof boundary: GitHub-hosted CI may prove simulator-safe checks only, while physical iPhone/TestFlight/WDA proof stays receipt-based unless a trusted self-hosted Mac and device lane is explicitly introduced.

## Original Request

"do this" after approving the Board 2.1 plan: improve CI reliability observability first, then later evaluate Swift hygiene tools report-only.

## Intake Summary

- Input shape: `existing_plan`
- Audience: Foil iOS maintainers and merge-queue contributors.
- Authority: `approved`
- Proof type: `test`
- Completion proof: Required hosted CI still passes `Hosted simulator sanity` and `Repo hygiene ratchet`, and simulator sanity failures/timeouts now identify the phase, command, destination, elapsed time, and sanitized text evidence needed to triage a hang.
- Goal oracle: `scripts/ios-simulator-sanity.sh` emits phase-level diagnostics and remains simulator-only; `.github/workflows/ios-simulator-sanity.yml` preserves required hosted checks and text-only/sanitized artifacts; local verification plus GitHub required CI prove the change.
- Likely misfire: Adding noisy process or physical-device claims instead of making the existing simulator lane diagnosable.
- Blind spots considered: hosted macOS/Xcode runner stalls, simulator boot/test hangs, xcodebuild output volume, artifact privacy, merge-queue runtime, CodeQL interaction, and the later SwiftFormat/SwiftLint/Periphery tranche.
- Existing plan facts: PR #62 initially timed out in `Run simulator-only sanity script` after `30m23s`, then rerun passed; merge-group run `28125684476` passed both required jobs at queue tip.

## Goal Oracle

The oracle for this tranche is:

`scripts/ios-simulator-sanity.sh` has bounded phase-level logging for project/scheme visibility, simulator tests, and unsigned generic iOS build; local verification passes; hosted required CI proves the workflow on GitHub without claiming physical-device coverage; final audit records the strongest realistic failure mode and the evidence that rules it out.

The PM must keep comparing receipts to this oracle. Planning, a new board, or a passing hygiene job alone is not enough.

## Goal Kind

`existing_plan`

## Current Tranche

Implement the first CI reliability observability slice. Defer Swift hygiene report-only probes to the next board task unless they are needed to complete this tranche.

## Non-Negotiable Constraints

- Preserve the privacy boundaries in `AGENTS.md`; do not commit provider keys, App Store Connect keys, private phone content, raw WDA accessibility trees, recordings, IPA/archive artifacts, or unsanitized physical-device evidence.
- Keep hosted GitHub CI honest: simulator-safe checks may be required; physical iPhone/TestFlight/WDA proof remains separate receipt-based evidence.
- Do not weaken the required `Hosted simulator sanity` or `Repo hygiene ratchet` checks.
- Keep artifacts text-only and sanitized.
- Do not make SwiftLint, SwiftFormat, or Periphery required in this tranche.
- Keep the hard max-lines rule enforced.

## Stop Rule

Stop only when a final audit proves this tranche is complete. If the simulator lane becomes red, inspect logs/artifacts and record whether it is a code regression, runner timeout, or workflow instrumentation issue before publishing.

## Canonical Board

Machine truth lives at:

`docs/goals/foil-ios-ci-reliability-observability/state.yaml`

If this charter and `state.yaml` disagree, `state.yaml` wins for task status, active task, receipts, verification freshness, and completion truth.

## Run Command

```text
/goal Follow docs/goals/foil-ios-ci-reliability-observability/goal.md.
```

