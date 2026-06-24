# Foil iOS CI Workflow Conveyor

## Objective

Prepare and execute the first CI workflow tranche for Foil iOS, while preserving
a conveyor outline for later max-lines, static-analysis, and preview-iPhone
runner work.

## Original Request

Create a conveyor outline plus a fully detailed Board 1 to drive Foil iOS
workflow development, including eventual hard max-lines-per-file enforcement.

## Intake Summary

- Input shape: `existing_plan`
- Audience: Foil iOS maintainers and future GoalBuddy/Codex runs.
- Authority: `approved`
- Proof type: `test`
- Completion proof: A final audit maps the implemented hosted CI/hygiene
  baseline to passing local verification, generated workflow/check names,
  claim-boundary wording, and queued follow-up boards.
- Goal oracle: Required hosted CI can honestly prove simulator-safe Foil iOS
  checks without overclaiming physical iPhone/TestFlight/WDA behavior, and the
  hygiene plan has a path from ratchet to hard max-lines enforcement.
- Likely misfire: The board ships a workflow that looks green but overclaims
  physical-device proof, skips generated-file drift, or leaves max-lines as a
  vague aspiration instead of an enforced future gate.
- Blind spots considered: hosted runner Xcode/simulator availability,
  XcodeGen installation, generated Info.plist/entitlements drift, artifact
  privacy, merge-queue required-check naming, current oversized source files,
  and untrusted-code risk on any future self-hosted iPhone runner.
- Existing plan facts:
  - Board 1 should be fully detailed.
  - Later boards should cover max-lines cleanup, hard hygiene gates, and the
    trusted preview-iPhone runner.
  - Hosted CI should cover only simulator-safe proof.
  - Physical iPhone/TestFlight/WDA proof stays receipt-based unless a trusted
    self-hosted Mac plus device lane is explicitly available.

## Goal Oracle

The oracle for this goal is:

`A final audit receipt proves Board 1 implemented a non-physical hosted CI and
repo-hygiene baseline, verifies it locally, records exact branch-protection
check names or required follow-up, and queues the later conveyor boards for
max-lines cleanup, hard hygiene gates, and preview-iPhone runner setup.`

The PM must keep comparing task receipts to this oracle. Planning, discovery, a
passing tiny slice, or a clean-looking board is not enough. The goal finishes
only when a final Judge/PM audit maps receipts and verification back to this
oracle and records `full_outcome_complete: true`.

## Goal Kind

`existing_plan`

## Current Tranche

Board 1 is the current tranche: add the hosted GitHub Actions and repo-hygiene
baseline needed before branch protection can require honest Foil iOS CI.

Board 1 should produce:

- A hosted non-physical GitHub Actions workflow.
- Xcode/XcodeGen/simulator visibility checks.
- XcodeGen generated-file drift detection.
- `git diff --check`.
- Python script syntax checks.
- `scripts/ios-physical-harness.py self-test`.
- The existing simulator sanity lane.
- A line-count audit and initial max-lines ratchet or explicit blocker if the
  first ratchet needs more design.
- Clear artifact and claim-boundary policy.
- Exact recommended required-check names for main protection/merge queue.

Conveyor follow-up boards:

1. Max-lines ratchet cleanup: split or shrink existing oversized files until the
   allowlist can go away.
2. Hard hygiene gates: enforce max-lines as a hard required gate and evaluate
   SwiftLint, SwiftFormat, and Periphery.
3. Trusted preview-iPhone runner: isolate a self-hosted Mac/device runner,
   add device locking and sanitized artifacts, then decide whether merge-group
   tip proof is safe to require.

## Non-Negotiable Constraints

- Hosted CI must not claim physical iPhone install, TestFlight, microphone or
  live provider proof, Full Access, WDA, or host-app keyboard insertion.
- Do not upload raw WDA source, private screenshots, provider keys, App Group
  snapshots with transcript bodies, recordings, IPA/archive artifacts, or broad
  temporary-directory globs.
- The preview iPhone runner must stay separate from hosted CI and must not run
  untrusted fork PR code.
- Branch protection/required-check updates may be recommended by exact name,
  but actual GitHub settings changes need explicit authority and suitable
  access.
- Hard max-lines enforcement is the desired end state. Any allowlist is a
  temporary migration tool.

## Stop Rule

Stop only when a final audit proves the full current tranche is complete and
the later conveyor boards are either queued with clear starter commands or
explicitly blocked with receipts.

Do not stop after planning, discovery, or Judge selection if a safe Worker task
can be activated.

Do not mark the current tranche complete while the hosted CI/hygiene baseline
or max-lines ratchet path is only described in prose.

## Slice Sizing

Safe means bounded, explicit, verified, and reversible. It does not mean tiny.

For Board 1, prefer one coherent Worker package for hosted CI plus baseline
hygiene if the Judge confirms the allowed files and verification commands are
adequate. Split only if workflow implementation, line-count tooling, or docs
claim-boundary work would otherwise blur verification.

## Board Health

The PM owns board health. If the board looks stale, misleading, offline, or
inconsistent, run:

```bash
node /Users/neonwatty/.codex/plugins/cache/goalbuddy/goalbuddy/0.3.9/skills/goalbuddy/scripts/check-goal-state.mjs docs/goals/ios-ci-workflow-conveyor
```

## Canonical Board

Machine truth lives at:

`docs/goals/ios-ci-workflow-conveyor/state.yaml`

If this charter and `state.yaml` disagree, `state.yaml` wins for task status,
active task, receipts, verification freshness, and completion truth.

## Run Command

```text
/goal Follow docs/goals/ios-ci-workflow-conveyor/goal.md.
```

## PM Loop

On every `/goal` continuation:

1. Read this charter.
2. Read `state.yaml`.
3. Re-check the intake, likely misfire, and claim boundary.
4. Work only on the active board task.
5. Write a compact task receipt.
6. Update the board.
7. Continue to the next largest safe local work package unless a phase/risk
   review or final audit is due.
8. Finish only with a Judge/PM audit receipt that records
   `full_outcome_complete: true`.
