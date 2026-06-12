# T001 Scout Receipt - Host-App Sterile Matrix Expansion

Date: 2026-06-09

## Claim

The current host-app matrix has useful historical evidence, but v0.47 cannot
claim fresh closed-beta coverage without current physical receipts.

## Rows scoped

- Safari normal field: rerun required for current-build pass.
- Safari secure/password field: rerun required for current-build expected
  rejection.
- Notes blank editor: requires a sterile editor precheck before staging text.
- Messages fake or dedicated draft: requires a sterile compose/draft surface and
  must not send.
- Reminders or another safe Apple text surface: useful additional row, but still
  requires intended-field and cleanup proof.
- Mail blank compose: deferred by issue #12.

## Strongest realistic failure modes

1. Old build 12 Safari proof gets reused as if it proved the current candidate.
2. Notes or Messages navigation exposes private content before a sterile surface
   is established.
3. A secure-field row is reported as passing without proving Foil Keyboard was
   absent and App Group remained staged.
4. Mail testing accidentally exposes inbox/account/private email content or
   requires sending mail.

## Proof strategy

Use WDA/equivalent physical automation only after a sterile surface exists, then
preserve sanitized receipts for pre-insert readiness, intended-field mutation,
App Group cleanup, and privacy scans.
