# T001 Scout Receipt - Physical Automation Hardening

Date: 2026-06-09

## Claim

The harness had useful narrow commands, but no single safe gate for deciding
whether an unattended run may touch host apps.

## Gaps

- `status` reported device/WDA/tooling state but did not classify next action.
- WDA failure could be rediscovered inside a private host-app board instead of
  before host-app navigation.
- The redaction helper self-test existed, but the readiness path did not require
  it before physical evidence collection.
- Cleanup/process state was documented in the runbook, but not included in a
  pre-host-app receipt.

## Strongest realistic failure mode

An autonomous run sees a connected phone and `iproxy`, assumes physical
automation is healthy, opens Notes or Messages, and then discovers WDA is dead
after private surface exposure.

## Proof strategy

Add a read-only `preflight` command that classifies health before any host app
is opened, emits sanitized evidence, and fails closed in strict mode.
