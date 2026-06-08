# T001 Parent Preflight Stop

## Status

The beta preflight child board ran far enough to hit the parent stop condition.

## Evidence

- Child Scout receipt:
  `docs/goals/ios-v0.23-beta-preflight/notes/T001-preflight-scout.md`
- Child Judge receipt:
  `docs/goals/ios-v0.23-beta-preflight/notes/T002-preflight-judge.md`
- WDA failure receipt:
  `docs/goals/ios-v0.23-beta-preflight/notes/receipts/wda-failure.json`
- Final harness status:
  `docs/goals/ios-v0.23-beta-preflight/notes/receipts/status-after-wda-retry.json`

## Decision

Do not advance to `docs/goals/ios-v0.23-testflight-rehearsal/goal.md` yet.

The child board records `operator_needed`: WDA/physical UI automation is down,
and current provider/key plus microphone permission cannot be verified from safe
read-only preflight receipts.

## Next Safe Action

Restore physical UI automation so WDA is ready at
`http://127.0.0.1:8100/status`, then finish the preflight audit. The alternate
route is an explicit board revision that approves the command-mailbox rehearsal
path, which mutates App Group state with sterile command files.
