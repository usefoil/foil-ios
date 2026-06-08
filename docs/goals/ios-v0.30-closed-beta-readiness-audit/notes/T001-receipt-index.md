# T001 Receipt Index

## Current Build And Repo State

| Criterion | Status | Evidence |
| --- | --- | --- |
| Source build metadata | Proven | `FoiliOS/project.yml` has `MARKETING_VERSION=0.1.0`, `CURRENT_PROJECT_VERSION=11`. |
| Preview iPhone installed build | Proven | `notes/receipts/installed-app-build.json` reports `com.neonwatty.FoilIOS` version `0.1.0`, build `11`. |
| Open PR queue | Clear | `notes/receipts/github-open-work.json` reports zero open PRs. |
| Deferred Mail row | Tracked | `notes/receipts/github-open-work.json` records open issue `#12`. |

## Host-App Matrix

| Row | Status | Evidence |
| --- | --- | --- |
| Safari normal text field | Pass | `docs/goals/ios-v0.26-apple-host-app-matrix-rerun/notes/receipts/safari-retry-before-insert.json`, `safari-retry-after-insert.json`, `safari-retry-app-group-after-insert.json`. |
| Safari secure/password field | Expected rejection pass | `docs/goals/ios-v0.26-apple-host-app-matrix-rerun/notes/receipts/safari-secure-focused.json`, `safari-secure-app-group-after-focus.json`, `safari-secure-cleanup.json`. |
| Notes sterile editor | Pass | `docs/goals/ios-v0.27-notes-row-proof/notes/receipts/notes-after-insert-retry.json`, `notes-app-group-after-insert-retry.json`. |
| Messages fake-recipient draft | Pass, draft-only | `docs/goals/ios-v0.29-messages-fake-recipient/notes/receipts/messages-fake-after-insert.json`, `messages-fake-draft-cleanup.json`, `messages-fake-app-group-cleanup.json`. |
| Messages existing/private thread | Not claimed | `docs/goals/ios-v0.28-messages-row-proof/notes/T999-final-audit.md` blocked before insertion when the visible thread was not sterile. |
| Mail blank compose | Deferred | GitHub issue `#12`, `docs/goals/ios-v0.20-host-app-matrix/notes/receipts/mail-compose-blocker.json`. |

## App-Side Dictation Path

| Criterion | Status | Evidence |
| --- | --- | --- |
| Installed build can produce a fresh transcript | Proven historically for build 11 | `docs/goals/ios-v0.23-testflight-rehearsal/notes/receipts/command-mailbox-rehearsal.json`. |
| App Group cleanup/reset | Proven across current matrix rows | v0.26 Safari cleanup, v0.27 Notes cleanup, v0.29 Messages cleanup. |
| Full Access / keyboard refresh friction | Known caveat | `docs/goals/ios-v0.8-keyboard-friction/notes/`, `docs/ios-testflight-feedback-v0.7.md`. |

## Superseded Prior No-Go

The v0.23 readiness audit was a no-go because WDA/equivalent physical UI
automation was unavailable. That blocker is superseded by v0.26-v0.29: WDA
direct URL testing produced fresh sanitized host-app receipts for Safari, Notes,
and Messages fake-recipient draft insertion.
