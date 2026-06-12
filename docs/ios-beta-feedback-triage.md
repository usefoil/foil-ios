# Foil iOS Beta Feedback Triage

Use this guide for closed-beta issues created from the iOS beta feedback form.

## Labels

Use existing GitHub labels first:

- `bug`: a tested setup, recording, transcription, insertion, or recovery path
  failed.
- `question`: incomplete report or unclear expected behavior.
- `documentation`: tester instructions, setup copy, runbook, or handoff issue.
- `enhancement`: ergonomic polish that is not blocking beta safety.

Add a short issue comment instead of requesting private material when evidence is
missing.

## Privacy Guardrails

Do not ask testers for:

- private transcript text;
- screenshots of private messages, email, contacts, notes, accounts, browser
  history, or thread lists;
- phone numbers, contact names, account names, recipient addresses, provider
  keys, or credentials.

Safe follow-up asks:

- TestFlight build number.
- iPhone model and iOS version.
- Target surface category.
- Whether the field was blank/test-only.
- Which setup boxes were complete.
- Which step failed.
- Whether Insert latest was enabled, inserted exactly once, disabled after
  insert, or stayed disabled.
- Which recovery step helped.

## Triage Buckets

| Bucket | Signals | First action |
| --- | --- | --- |
| Setup route | Use my Mac, iPhone API key, Advanced / Support | Confirm which route was selected. For build `0.1.0 (13)`, API key on iPhone is the usable tester path; Mac pairing is future/recommended copy unless a Mac-pairing test is explicitly requested. |
| Setup readiness | TestFlight, provider key, microphone, Add Keyboard, Full Access, Keyboard health | Confirm setup state and point to handoff recovery steps. Do not treat setup as complete unless Foil shows keyboard health ready after a real keyboard check-in. |
| Recording | Recording did not start/finish, wrong microphone state | Ask for build/device/iOS and whether retry with a short safe phrase worked. |
| Transcription | Transcript never appears, provider failure, network failure | Ask whether provider key is saved and whether recovery copy appeared. |
| Keyboard refresh | Foil Keyboard missing, stale state, refocus/cycle required | Ask which refocus/cycle/reset step changed the state. |
| Insertion | Insert latest disabled, double insert, no insert, stale insert | Confirm target surface, field sterility, and exactly-once/disabled-after-insert result. |
| Host app privacy | Notes/Messages/Mail/private content appeared | Stop the row; do not ask for screenshots or content. |

## Close Criteria

A feedback issue is actionable when it includes build, device/iOS, target
surface, setup route, keyboard health state, sterile-field status, failed step,
recovery step tried, and privacy confirmation. If any of those are missing, ask
for only the missing safe fields.

## Build 13 Release Gate

For build `0.1.0 (13)`, do not downgrade a tester report just because setup was
not complete. The release gate intentionally proved that Foil refuses readiness
when Foil Keyboard has not checked in recently, then becomes ready only after a
sterile keyboard refresh. File stale-keyboard reports under **Keyboard refresh**
unless the app claims setup complete while keyboard health is still stale.
