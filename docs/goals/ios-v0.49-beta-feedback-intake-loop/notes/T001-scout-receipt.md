# T001 Scout Receipt - Beta Feedback Intake Loop

Date: 2026-06-09

## Claim

The repo had a useful tester handoff, but no structured GitHub intake path and
no triage guide for privacy-safe follow-up.

## Gaps

- `.github/ISSUE_TEMPLATE/` did not exist.
- Feedback was free-form, which increases the chance of missing build/device,
  setup state, target surface, exact failure step, or recovery result.
- Free-form reports could accidentally include private transcripts, screenshots,
  contacts, messages, email content, account names, phone numbers, provider
  keys, or credentials.
- Existing labels are generic, so triage docs should map iOS beta buckets onto
  existing labels without requiring label administration.

## Strongest realistic failure mode

The issue form asks for "what text did you dictate?" or screenshots, causing
testers to disclose private transcript or host-app content.

## Proof strategy

Add a structured issue form, update the handoff, and add a triage guide. Then
scan all changed intake artifacts for unsafe private-content asks.
