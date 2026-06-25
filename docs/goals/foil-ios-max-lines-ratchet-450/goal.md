# Foil iOS Max Lines Ratchet to 450

## Objective

Lower Foil iOS's hard source line-count ceiling from 500 to 450 by completing the smallest safe refactor needed to make the stricter gate pass, then land it through the required GitHub merge queue.

## Original Request

The user approved the next tranche: make Board 2 for the hard max-lines ratchet, likely lowering the cap from 500 to 450 after safely splitting the largest file.

## Intake Summary

- Input shape: `specific`
- Audience: Foil iOS maintainers using hard repo hygiene gates and merge queue protection
- Authority: `requested`
- Proof type: `artifact`
- Completion proof: a merge-queued PR lands with `scripts/source-line-ratchet.py --json` reporting `max_lines: 450`, no allowlist, no violations, and the required simulator-safe CI contexts passing.
- Goal oracle: local line-ratchet/self-test/whitespace/targeted Swift verification plus PR and merge-group evidence for `Repo hygiene ratchet` and `Hosted simulator sanity`.
- Likely misfire: lowering a documented number without actually enforcing it, adding an allowlist to avoid refactoring, or refactoring UI code in a way that changes first-run/onboarding behavior without enough tests.
- Blind spots considered: `ContentView.swift` is the only file above 450, but it is user-facing SwiftUI shell code; a careless split could alter environment wiring, onboarding presentation, provider configuration, or keyboard/setup flows.
- Existing plan facts: the previous v2 board landed fixture self-tests for the line ratchet and whitespace scanner; `main` currently has max 500, empty allowlist, no violations, and largest file `FoiliOS/FoilIOSApp/ContentView.swift` at 480 lines.

## Goal Oracle

The oracle for this goal is:

`A merge-queued PR lands with the hard source line-count ceiling lowered to 450, no allowlist, no counted-file violations, relevant local Swift checks passing, and required merge-queue contexts passing.`

The PM must keep comparing task receipts to this oracle. Planning, discovery, a passing local line scan, or a clean-looking board is not enough. The goal finishes only when a final Judge/PM audit maps receipts and verification back to this oracle and records `full_outcome_complete: true`.

## Goal Kind

`specific`

## Current Tranche

Complete a focused line-count ratchet from 500 to 450. The expected implementation path is to scout `ContentView.swift`, decide the safest extraction or shrink, execute that bounded refactor, lower the hard cap, verify locally, publish through PR, and collect merge-queue evidence.

## Non-Negotiable Constraints

- Keep the line-count allowlist empty unless a Judge explicitly rejects the tranche as unsafe; the intended outcome is a stricter hard gate, not a bypass.
- Do not weaken hosted simulator, repo hygiene, generated-project drift, CodeQL, or physical evidence boundaries.
- Do not claim physical iPhone/TestFlight/WDA proof; this tranche is simulator-safe CI and source hygiene only.
- Preserve user-facing behavior in the app shell, onboarding, provider configuration, and keyboard/setup paths.
- Use focused Swift refactors that follow existing project patterns. Avoid unrelated style churn.
- Before declaring complete, try to disprove the strongest realistic failure mode using `docs/acceptance-evidence.md` guidance.

## Stop Rule

Stop only when a final audit proves the full original outcome is complete.

Do not stop after planning, discovery, or Judge selection if a safe Worker task can be activated.

Do not stop after a local refactor passes if the broader outcome still requires PR and merge-queue proof.

## Slice Sizing

Safe means bounded, explicit, verified, and reversible. It does not mean tiny.

The first useful Worker slice should be the largest safe bounded package that can lower the cap to 450. If scouting proves only `ContentView.swift` blocks the cap, prefer one coherent extraction/refactor plus the cap change over a sequence of helper-only tasks.

## Board Health

The PM owns board health. If the board looks stale, misleading, offline, or inconsistent, run:

```bash
node /Users/neonwatty/.codex/plugins/cache/goalbuddy/goalbuddy/0.3.9/skills/goalbuddy/scripts/check-goal-state.mjs docs/goals/foil-ios-max-lines-ratchet-450/state.yaml
```

## Canonical Board

Machine truth lives at:

`docs/goals/foil-ios-max-lines-ratchet-450/state.yaml`

If this charter and `state.yaml` disagree, `state.yaml` wins for task status, active task, receipts, verification freshness, and completion truth.

## Run Command

```text
/goal Follow docs/goals/foil-ios-max-lines-ratchet-450/goal.md.
```

## PM Loop

On every `/goal` continuation:

1. Read this charter.
2. Read `state.yaml`.
3. Re-check the intake, oracle, likely misfire, and constraints.
4. Work only on the active board task.
5. Write compact receipts and update the next active task.
6. Finish only with a Judge/PM audit receipt that maps receipts and verification to the oracle and records `full_outcome_complete: true`.
