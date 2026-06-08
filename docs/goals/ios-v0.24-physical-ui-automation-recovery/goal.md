# Foil iOS v0.24 Physical UI Automation Recovery

## Original Request

Recover the physical iPhone UI automation path so closed-beta host-app insertion
testing can continue.

## Outcome

Restore WebDriverAgent or an equivalent physical-device tap/snapshot path for
`iPhone-preview`, then prove it with privacy-safe receipts before rerunning the
Apple host-app matrix.

## Oracle

This board is complete only when the physical iPhone automation path can create
a current-app session, fetch a sanitized source/snapshot from a sterile surface,
and perform one safe interaction, or when the exact external blocker and owner
action are proven with logs that rule out local fixes.

## Non-Goals

- Do not rerun private Messages, Mail, Safari, or Notes rows until physical UI
  control is restored.
- Do not commit raw WDA accessibility trees, screenshots from private apps,
  provider keys, JWTs, transcripts, contacts, or private phone content.
- Do not change product UX or transcription behavior unless diagnostics prove
  the automation blocker is caused by repo code.

## Starter Command

`/goal Follow docs/goals/ios-v0.24-physical-ui-automation-recovery/goal.md.`
