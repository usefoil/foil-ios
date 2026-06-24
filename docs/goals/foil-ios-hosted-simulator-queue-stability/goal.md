# Foil iOS Hosted Simulator Queue Stability

## Objective

Make Foil iOS merge-queue hosted simulator proof reliable enough to land CI/receipt-only changes without repeated `simulator-tests` script-owned timeouts, while preserving the honest simulator-only/physical-device proof boundary.

## Original Request

"ok do this" in response to the proposed next board: investigate why PR-level hosted simulator passes while merge-group queue-tip runs timeout in `phase=simulator-tests`, then implement the smallest CI change that makes queue-tip proof reliable without watering down coverage.

## Intake Summary

- Input shape: `specific`
- Audience: Foil iOS maintainers using GitHub branch protection and merge queue
- Authority: `requested`
- Proof type: `artifact`
- Completion proof: A PR for this tranche passes PR-level required checks, survives merge queue at queue tip, and lands on `main`, or a final audit records a concrete external blocker with sanitized artifacts showing why no safe local fix remains.
- Goal oracle: GitHub merge-group `iOS Simulator Sanity (non-physical)` no longer repeatedly times out in `phase=simulator-tests` for a receipt/docs-only change; any failure remains phase-diagnosable with sanitized text artifacts.
- Likely misfire: weakening simulator coverage or bypassing required checks so the queue passes without proving project/scheme visibility, simulator tests, and unsigned generic iOS build.
- Blind spots considered: merge-group runner behavior can differ from pull_request runner behavior; retries can hide legitimate regressions; splitting jobs can improve evidence but may require branch-protection updates; physical iPhone/TestFlight/WDA proof must stay separate.
- Existing plan facts: PR #63 merged the observability layer; PR #64 is PR-green but failed merge queue twice at `phase=simulator-tests` after 1200s; artifacts were downloaded to `/tmp/foil-pr64-merge-artifacts` and `/tmp/foil-pr64-merge2-artifacts`.

## Goal Oracle

The oracle for this goal is:

`A branch containing the queue-stability fix passes local verification, PR-level GitHub checks, and a merge-group run without repeated simulator-test timeout; final receipts map any remaining timeout to a named phase and artifact.`

The PM must keep comparing task receipts to this oracle. Planning, discovery, a passing PR run without merge-group evidence, or a clean-looking board is not enough. The goal finishes only when a final Judge/PM audit maps receipts and verification back to this oracle and records `full_outcome_complete: true`, or records a specific blocker with evidence.

## Goal Kind

`specific`

## Current Tranche

Investigate the merge-queue-only simulator timeout and implement the smallest reversible CI/script/workflow change that improves queue-tip reliability without reducing Foil iOS's simulator-safe proof surface. If the failure is external hosted-runner instability, preserve coverage and make retry/phase behavior explicit and auditable rather than silently weakening checks.

## Non-Negotiable Constraints

- Do not claim hosted CI proves physical iPhone, TestFlight, keyboard insertion, or WDA behavior.
- Do not commit provider keys, App Store Connect keys, JWTs, private phone content, raw WDA trees, recordings, IPA/archive artifacts, or unsanitized device data.
- Do not remove project/scheme visibility, simulator tests, unsigned generic iOS build, repo hygiene, CodeQL, or hard max-lines ratchet coverage unless a Judge receipt explicitly rejects that path as unsafe.
- Keep receipt/docs-only PR #64 separate; this branch starts from `origin/main`.
- Prefer small, observable changes to `.github/workflows/ios-simulator-sanity.yml`, `scripts/ios-simulator-sanity.sh`, and CI docs.

## Stop Rule

Stop only when a final audit proves the full original outcome is complete or records a concrete external blocker.

Do not stop after planning, discovery, or Judge selection if a safe Worker task can be activated.

Do not stop after a single verified Worker package when the broader owner outcome still has safe local follow-up work. Advance the board to the next highest-leverage safe Worker package and continue unless a phase, risk, rejected-verification, ambiguity, or final-completion review is due.

## Slice Sizing

Safe means bounded, explicit, verified, and reversible. It does not mean tiny.

A good task is the largest safe useful slice: a coherent CI reliability improvement with local verification and hosted evidence. Tiny tasks are allowed only when the failure is isolated or the scope is uncertain.

## Board Health

The PM owns board health. If the board looks stale, misleading, offline, or inconsistent, run:

```bash
node /Users/neonwatty/.codex/plugins/cache/goalbuddy/goalbuddy/0.3.9/skills/goalbuddy/scripts/check-goal-state.mjs docs/goals/foil-ios-hosted-simulator-queue-stability/state.yaml
```

## Canonical Board

Machine truth lives at:

`docs/goals/foil-ios-hosted-simulator-queue-stability/state.yaml`

If this charter and `state.yaml` disagree, `state.yaml` wins for task status, active task, receipts, verification freshness, and completion truth.

## Run Command

```text
/goal Follow docs/goals/foil-ios-hosted-simulator-queue-stability/goal.md.
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
