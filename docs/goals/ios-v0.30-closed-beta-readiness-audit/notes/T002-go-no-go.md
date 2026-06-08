# T002 Go/No-Go

## Decision

`go_narrow_internal_beta_with_caveats`

## Why This Is Now A Go

The current evidence supports a small internal TestFlight beta for the core
Foil iOS loop:

- installed preview-phone build is `0.1.0 (11)`;
- app-side recording/transcription/App Group handoff is proven on build 11;
- Foil Keyboard exact-once insertion is proven in Notes, Safari normal text,
  and Messages fake-recipient draft;
- secure/password field rejection is proven as expected behavior;
- no open PRs are waiting to merge;
- the one intentionally skipped Apple row, Mail, is tracked in issue `#12`.

## Caveats For Tester Instructions

- This is not arbitrary app support.
- Mail is deferred.
- Messages support should be described as draft insertion in a fake-recipient
  compose surface, not delivery or existing private-thread behavior.
- Secure fields reject custom keyboards; testers should treat that as expected.
- Testers may need to enable Full Access, cycle keyboards, or refocus the host
  field before Insert latest appears.
- Testers should use sterile text targets and avoid sharing private screenshots
  or message/email content in feedback.

## Not Required Before Closed Beta

- Mail blank compose proof, because it is tracked and intentionally deferred.
- Real-recipient Messages delivery proof, because beta copy can avoid delivery
  claims.
- Broad third-party app matrix coverage, because the claim boundary is narrow.

## Recommended Next Board

Create a tester-facing polish/checklist board:

`docs/goals/ios-v0.31-closed-beta-tester-handoff/`

Suggested contents: beta invitation copy, setup checklist, Full Access
instructions, known caveats, sterile feedback template, and a final scan that no
public text overclaims Mail, delivery, or arbitrary app support.
