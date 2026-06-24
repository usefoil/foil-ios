# Foil iOS Hard Hygiene Gates

## Objective

Drive Foil iOS from the newly merged hosted CI ratchet to a hard hygiene posture: shrink the temporary max-lines allowlist, preserve honest simulator-only proof, and prepare any Swift static-analysis gates only when they are configured enough to be trustworthy.

## Original Request

"do this" after agreeing that the next step is Board 2: sync main, create a GoalBuddy board for hard hygiene gates, shrink the max-lines allowlist, evaluate SwiftLint/SwiftFormat/Periphery carefully, and eventually flip the ratchet into a hard no-exceptions max-lines rule.

## Intake Summary

- Input shape: `existing_plan`
- Audience: Foil iOS maintainers and future merge-queue contributors.
- Authority: `approved`
- Proof type: `test`
- Completion proof: Required CI on `main` enforces a hard max-lines-per-file rule with no temporary oversized allowlist, and any additional Swift hygiene gates are either verified as trustworthy or explicitly deferred with evidence.
- Goal oracle: `scripts/source-line-ratchet.py` and GitHub required CI prove there are no allowlisted oversized files, while `scripts/ios-simulator-sanity.sh` continues to pass without adding physical-device claims.
- Likely misfire: The board could add more process or lint noise while leaving the oversized files allowlisted, or it could make Swift static-analysis checks required before false positives are understood.
- Blind spots considered: SwiftUI file-splitting risk, test readability while splitting large tests, physical harness redaction/privacy boundaries, merge-queue runtime cost, generated Xcode project drift, and false positives from Periphery around SwiftUI, tests, app extensions, and XcodeGen.
- Existing plan facts: Board 1 merged PR #60, added `iOS Simulator Sanity (non-physical)`, required `Hosted simulator sanity` and `Repo hygiene ratchet`, and introduced `scripts/source-line-ratchet.py` with a 500-line threshold plus temporary baselines for four oversized files.

## Goal Oracle

The oracle for this goal is:

`scripts/source-line-ratchet.py` reports zero allowlist baselines and zero violations; hosted required CI on `main` passes `Hosted simulator sanity` and `Repo hygiene ratchet`; final audit confirms no physical iPhone/TestFlight/WDA proof was moved into hosted CI.

The PM must keep comparing task receipts to this oracle. Planning, discovery, one split file, or a clean-looking board is not enough. The goal finishes only when a final Judge/PM audit maps receipts and verification back to this oracle and records `full_outcome_complete: true`.

## Goal Kind

`existing_plan`

## Current Tranche

Complete successive safe verified slices until the temporary max-lines allowlist is gone and the hard max-lines rule is enforced. Use Scout/Judge before broad refactors because the four oversized files have different risks: app UI composition, presenter logic, test organization, and physical automation receipt handling.

## Non-Negotiable Constraints

- Preserve the privacy boundaries in `AGENTS.md`; do not commit provider keys, App Store Connect keys, private phone content, raw WDA accessibility trees, recordings, IPA/archive artifacts, or unsanitized physical-device evidence.
- Keep hosted GitHub CI honest: simulator-safe checks may be required; physical iPhone/TestFlight/WDA proof remains separate receipt-based evidence unless a trusted self-hosted device lane is explicitly introduced.
- Do not relax or remove the existing simulator sanity workflow while shrinking files.
- Do not promote SwiftLint, SwiftFormat, or Periphery to required CI until a Scout/Judge receipt proves the configuration is stable enough for Foil iOS and the failure mode is acceptable.
- Keep generated Xcode project drift checked after changes that could affect project structure.
- Use the repo's existing patterns and narrow file moves; avoid unrelated redesigns.

## Stop Rule

Stop only when a final audit proves the full original outcome is complete.

Do not stop after planning, discovery, or Judge selection if a safe Worker task can be activated.

Do not stop after a single verified Worker package when the broader max-lines outcome still has safe local follow-up work. Advance the board to the next highest-leverage safe Worker package unless a phase, risk, rejected-verification, ambiguity, or final-completion review is due.

Do not create one Worker/Judge pair for every tiny helper. Put repeated same-shape file extraction work into one coherent Worker package when boundaries are clear and verification is strong.

## Slice Sizing

Safe means bounded, explicit, verified, and reversible. It does not mean tiny.

A good Worker package removes real allowlist pressure while preserving behavior and test coverage. A bad package only renames files or adds style rules without reducing the current hard-gate blocker.

## Board Health

The PM owns board health. If the board looks stale, misleading, offline, or inconsistent, run:

```bash
node /Users/neonwatty/.codex/plugins/cache/goalbuddy/goalbuddy/0.3.9/skills/goalbuddy/scripts/check-goal-state.mjs docs/goals/foil-ios-hard-hygiene-gates/state.yaml
```

Repair only GoalBuddy control files unless an active Worker or PM task explicitly allows product-file edits.

## Canonical Board

Machine truth lives at:

`docs/goals/foil-ios-hard-hygiene-gates/state.yaml`

If this charter and `state.yaml` disagree, `state.yaml` wins for task status, active task, receipts, verification freshness, and completion truth.

## Run Command

```text
/goal Follow docs/goals/foil-ios-hard-hygiene-gates/goal.md.
```

## PM Loop

On every `/goal` continuation:

1. Read this charter.
2. Read `state.yaml`.
3. Run the bundled GoalBuddy update checker when available and mention a newer version without blocking.
4. Re-check the intake, oracle, privacy boundaries, and likely misfire.
5. Work only on the active board task.
6. Write a compact task receipt.
7. Update the board.
8. If safe local work remains, choose the next largest reversible Worker package and continue unless blocked.
9. Review at phase, risk, rejected-verification, ambiguity, or final-completion boundaries.
10. Finish only with a Judge/PM audit receipt that maps receipts and verification back to the original user outcome and records `full_outcome_complete: true`.
