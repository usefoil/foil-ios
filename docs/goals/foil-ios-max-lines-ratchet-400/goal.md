# Foil iOS Max Lines Ratchet to 400

## Original Request

The user asked to continue the hard max-lines ratchet work and execute the next tranche.

## Outcome

Lower Foil iOS's enforced source/script/workflow max-lines gate from 450 to 400 without using an allowlist, while preserving simulator-safe CI proof boundaries and merging through the protected merge queue.

## Oracle

The tranche is complete only when a merge-queued PR lands on `main` with:

- `scripts/source-line-ratchet.py --json` reporting `max_lines` 400.
- `allowlist_baselines` empty.
- `violations` empty.
- Required simulator-safe CI contexts passing on the PR and merge-group branch.
- A final GoalBuddy closeout receipt recording the merged proof.

## Constraints

- Do not use an allowlist to dodge the ratchet.
- Do not weaken the existing CI workflows, scripts, or proof boundaries.
- Treat physical iPhone, TestFlight, and WDA evidence as separate receipt-based proof.
- Preserve user-facing app behavior and shared App Group/keyboard bridge behavior.
- Use focused tests and merge-queue evidence; do not call local checks complete proof for the whole tranche.

## Likely Misfire

The easiest wrong success is lowering a constant or documentation while leaving one of the counted files over 400, or refactoring the two largest files in a way that compiles but changes app-shell or keyboard bridge behavior.

## Starter Command

`/goal Follow docs/goals/foil-ios-max-lines-ratchet-400/goal.md.`
