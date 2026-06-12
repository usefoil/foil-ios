# T003 Judge Audit - Beta Feedback Intake Loop

Date: 2026-06-09

## Claim

The feedback intake artifacts are actionable and privacy-safe enough to merge.

## Strongest realistic failure mode

The new template or docs request private content, credentials, phone numbers,
contact names, screenshots of private apps, or raw transcript text.

## Evidence

- `git diff --check`
- `ruby -e 'require "yaml"; YAML.load_file(".github/ISSUE_TEMPLATE/ios_beta_feedback.yml"); puts "issue form yaml ok"'`
- `rg -n "private transcript|screenshots of private|phone numbers|contact names|account names|provider keys|credentials|Do not include|Do not ask" .github/ISSUE_TEMPLATE/ios_beta_feedback.yml docs/ios-beta-feedback-triage.md docs/ios-closed-beta-tester-handoff.md README.md`
- `rg -n "paste.*transcript|send.*screenshot|phone number|contact name|account name|credential|provider key" .github/ISSUE_TEMPLATE/ios_beta_feedback.yml docs/ios-beta-feedback-triage.md docs/ios-closed-beta-tester-handoff.md README.md`

## Decision

Pass. The artifacts request build/device/target/setup/result/recovery state and
explicitly prohibit private transcript text, screenshots of private apps,
contacts, messages, email content, account names, phone numbers, provider keys,
and credentials. The only provider-key mention is setup-state confirmation, not
key disclosure.
