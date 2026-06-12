# T002 Worker Receipt - Beta Feedback Intake Loop

Date: 2026-06-09

## Claim

Closed-beta testers now have a structured, privacy-safe feedback path.

## Changes

- Added `.github/ISSUE_TEMPLATE/ios_beta_feedback.yml`.
- Added `docs/ios-beta-feedback-triage.md`.
- Updated `docs/ios-closed-beta-tester-handoff.md` to point testers at the
  issue form and tell them to stop if a target app opens to private content.
- Updated `README.md` with the feedback form and triage doc locations.

## Evidence

- The issue form asks for build, device/iOS, target surface, sterile-field
  status, setup state, result, failure area, recovery steps, non-private notes,
  and privacy confirmation.
- The form uses the existing `question` label.
- The triage guide maps reports to existing labels: `bug`, `question`,
  `documentation`, and `enhancement`.

## Residual risk

GitHub issue forms cannot prevent a tester from typing private content into a
free-text field. The form and handoff both explicitly tell testers not to do
that, and the triage guide tells maintainers not to request it.
