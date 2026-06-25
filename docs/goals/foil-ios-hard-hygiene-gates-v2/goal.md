# Foil iOS Hard Hygiene Gates v2

## Objective

Make Foil iOS hygiene gates explicit, hard, and merge-queue-aligned now that the hosted simulator CI layer has proven stable.

## Original Request

"continue" after identifying the next highest-leverage step as a new GoalBuddy board for hard hygiene gates v2.

## Intake Summary

- Input shape: `specific`
- Audience: Foil iOS maintainers using GitHub branch protection and merge queue
- Authority: `requested`
- Proof type: `artifact`
- Completion proof: A PR lands through the merge queue with updated hygiene gates, docs, and evidence that required GitHub contexts still match the branch-protection/merge-queue contract.
- Goal oracle: Current `main` has hard, documented, verified hygiene gates for source whitespace, generated-project drift, syntax/self-test checks, and a max-lines rule that fails CI when violated.
- Likely misfire: adding aspirational docs or a soft ratchet while branch protection and CI still allow oversized files or stale required contexts.
- Blind spots considered: GitHub branch-protection required contexts may need an external settings check; a strict line cap could block useful work if current baselines are not staged carefully; Swift files may require a staged ceiling rather than an immediate lower cap.
- Existing plan facts: PRs #65, #66, and #64 proved the hosted simulator and repo hygiene workflows through PR checks and merge queue. The current repo already has `scripts/source-line-ratchet.py`, `scripts/source-whitespace-check.py`, simulator-safe CI, and a desire for an eventually hard max-lines-per-file rule.

## Goal Oracle

The oracle for this goal is:

`A merge-queued PR lands with explicit hard hygiene gates, a documented max-lines policy, verified local checks, and GitHub required-check evidence that matches the branch-protection contract.`

The PM must keep comparing task receipts to this oracle. Planning, a local-only script pass, or a green PR without merge-group proof is not enough.

## Goal Kind

`specific`

## Current Tranche

Audit the existing hygiene gates and GitHub required-check contexts, choose the largest safe hardening slice, implement the first hard gate package, and land it through the merge queue.

## Non-Negotiable Constraints

- Do not weaken hosted simulator, repo hygiene, CodeQL, project/scheme visibility, simulator tests, unsigned generic iOS build, or generated-project drift checks.
- Do not claim physical iPhone, TestFlight, keyboard insertion, or WDA proof from hosted CI.
- Do not commit provider keys, App Store Connect keys, JWTs, private phone content, raw WDA trees, recordings, IPA/archive artifacts, or unsanitized device data.
- Keep line-cap enforcement honest: if a staged cap is needed, document the exact ceiling, current largest files, and ratchet path.
- Prefer existing repo scripts and workflow patterns over new tooling unless Scout/Judge evidence shows a real gap.
- Avoid broad refactors unless required to make an already-violating file pass an approved hard ceiling.

## Stop Rule

Stop only when a final audit proves the full tranche is complete or records a concrete blocker with evidence.

Do not stop after discovery if a safe Worker task can be activated.

Do not stop after a PR-level green run if merge-group proof is still pending.

## Slice Sizing

The first Worker slice should be the largest safe useful gate-hardening package selected by Judge after Scout maps current scripts, workflows, docs, and branch-protection evidence.

Safe means bounded, explicit, verified, and reversible. It does not mean tiny.

## Board Health

The PM owns board health. If the board looks stale, misleading, offline, or inconsistent, run:

```bash
node /Users/neonwatty/.codex/plugins/cache/goalbuddy/goalbuddy/0.3.9/skills/goalbuddy/scripts/check-goal-state.mjs docs/goals/foil-ios-hard-hygiene-gates-v2/state.yaml
```

## Canonical Board

Machine truth lives at:

`docs/goals/foil-ios-hard-hygiene-gates-v2/state.yaml`

If this charter and `state.yaml` disagree, `state.yaml` wins for task status, active task, receipts, verification freshness, and completion truth.

## Run Command

```text
/goal Follow docs/goals/foil-ios-hard-hygiene-gates-v2/goal.md.
```

## PM Loop

On every continuation:

1. Read this charter.
2. Read `state.yaml`.
3. Work only on the active board task.
4. Write a compact task receipt.
5. Update the board.
6. Verify with local commands and GitHub artifacts appropriate to the task.
7. Finish only with a Judge/PM audit receipt that maps receipts and verification back to the original user outcome.
