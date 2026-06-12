# Foil iOS Autonomous GoalBuddy Conveyor

## Outcome

Prepare and run a GoalBuddy-controlled conveyor that turns Foil iOS work into
successive prep boards with measurable acceptance criteria, then carries each
board through branch work, PR creation, CI/CD monitoring, green merge,
conflict recovery, local main refresh, and timed handoff to the next board.

## Oracle

The conveyor is healthy only when the active board has:

- a concrete task list with measurable acceptance criteria and stop conditions;
- a branch or PR link when implementation or publication is required;
- current CI/CD and conflict status recorded in a receipt;
- merge proof or an exact blocker before the next board is activated;
- a timed Codex reminder or heartbeat that can wake this thread to continue
  the next board without relying on memory;
- no unverified claim that a PR is green, merged, conflict-free, or complete.

The current tranche is complete when the first conveyor cycle has either merged
the current PR cleanly or recorded an exact blocker, created the next prep board
from the measured residual work, and installed or updated the timed reminder for
the next cycle.

## Conveyor Shape

1. `ios-autonomous-goalbuddy-conveyor`: parent/controller board.
2. `ios-route-first-onboarding-followthrough`: first child board, focused on
   PR #40 monitoring, CI/CD, merge readiness, conflicts, and post-merge next
   task discovery.
3. Future child boards are created only after the active child board proves its
   merge/blocker state and records measured residual work.

## Acceptance Standard

Each child board must define:

- owner outcome and likely misfire;
- measurable acceptance criteria;
- exact verification commands or GitHub/CI evidence;
- PR target, branch, and merge preconditions;
- conflict and failing-check recovery policy;
- privacy boundaries for receipts;
- timer/heartbeat handoff instructions for the next cycle.

## Autonomous Rules

- Work one active task at a time.
- Do not merge unless the PR is green, current with base or intentionally
  mergeable under repo rules, and the board receipt records the proof.
- If CI fails, create or activate the smallest safe Worker task that fixes the
  failure, verifies locally, pushes, and returns to monitoring.
- If conflicts appear, create or activate a conflict-recovery Worker task with
  explicit allowed files and verification before pushing.
- If merging requires human-only permissions, mark the merge task blocked with
  the exact missing permission and continue with safe local next-board prep.
- After merge or exact blocker, update local `main`, create the next child prep
  board from residual work, and rely on the timed reminder to continue.
- Do not store provider keys, App Store Connect secrets, private phone content,
  raw WDA trees, or temporary IPA/archive artifacts in board receipts.

## Starter Command

`/goal Follow docs/goals/ios-autonomous-goalbuddy-conveyor/goal.md.`
