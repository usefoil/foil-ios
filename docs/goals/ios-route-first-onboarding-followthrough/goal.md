# Foil iOS Route-First Onboarding Followthrough

## Outcome

Carry PR #40 from draft route-first onboarding polish through fresh PR status
inspection, CI/CD monitoring, conflict or failing-check repair, merge when green
and permitted, local main refresh, residual-work discovery, and handoff to the
next GoalBuddy prep board.

## Oracle

This child board is complete only when PR #40 is either:

- merged with fresh GitHub evidence, local `main` refreshed, and residual work
  converted into the next child prep board; or
- exactly blocked with the current GitHub/permission/conflict/check evidence,
  owner/action, and a timed reminder that can wake the parent conveyor.

Local tests, happy-path screenshots, draft PR existence, and stale CI state are
not sufficient proof. Merge readiness requires fresh GitHub check, review, and
mergeability evidence.

## Acceptance Criteria

- PR #40 status is recorded from fresh GitHub evidence.
- CI/CD checks are recorded by name and conclusion.
- Mergeability and conflict state are recorded.
- Any failing check or conflict has a bounded Worker task with allowed files,
  verification commands, and stop conditions.
- Merge happens only when checks are green and repo rules permit it.
- If merge is blocked by permission or branch protection, the exact blocker is
  recorded and the board still creates safe next prep.
- The parent conveyor board is updated with this child board's receipt.
- The timed reminder points at the active board and tells the next run to gather
  fresh evidence before claiming PR/CI/merge state.

## Privacy And Safety

- Do not commit provider keys, App Store Connect keys, JWTs, private phone
  content, raw WDA trees, screenshots with private content, or IPA/archive
  artifacts.
- Do not resolve conflicts by discarding user changes.
- Do not mark this board complete while a queued Worker is still required.

## Starter Command

`/goal Follow docs/goals/ios-route-first-onboarding-followthrough/goal.md.`
