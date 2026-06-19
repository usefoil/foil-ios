# T003 Judge Physical Blocker

Superseded: this was the original physical blocker. It was later resolved by
T006 onboarding-ready physical receipts, and PR #27 merged into
`usefoil/foil-ios` on 2026-06-19.

Result: `external_blocker`

## Decision

The v0.42 implementation is locally verified but cannot be approved for merge
as a completed child board yet, because its oracle requires physical iPhone
proof and the preview phone is not currently available for that proof.

## Evidence

- PR state:
  - `gh pr view 27 --json number,state,isDraft,mergeStateStatus,url,statusCheckRollup,headRefName,baseRefName`
  - PR #27 is open, draft, clean, and has no status checks.
- GoalBuddy state:
  - `check-goal-state.mjs docs/goals/ios-v0.42-first-run-onboarding-polish/state.yaml`
  - Passed with T003 active before this blocker receipt.
- Physical preflight:
  - `scripts/ios-physical-harness.py status`
  - `iPhone-preview` entry present, `iproxy` present, WDA project present,
    WDA not ready at `http://127.0.0.1:8100`.
  - `xcrun devicectl list devices`
  - `iPhone-preview` reported `unavailable`.

## What Is Proven

- The onboarding readiness summary compiles and passes simulator tests.
- Simulator semantic UI proof covers first-run, partial keyboard-not-verified,
  and ready-to-insert states.
- Copy scans did not find new broad iPhone app, Mail support, Messages delivery,
  secure-field support, or public App Store claims.

## What Is Not Proven

- The branch has not been installed on `iPhone-preview`.
- The new setup readiness summary has not been observed on the physical phone.
- Physical first-run, returning-user, blocked-keyboard, and setup-complete
  receipts are missing.

## Required Next Action

Operator action is required:

1. Make `iPhone-preview` available/unlocked to CoreDevice.
2. Approve installing the PR #27 development build on that phone.
3. Start or recover WDA/equivalent physical UI automation.

After that, rerun the v0.42 Judge gate and convert PR #27 from draft only if
the physical receipts pass.
