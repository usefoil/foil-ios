# T001 Board And PR Audit

## Decision

`prerequisites_merged_or_exact`

## Child Board State

| Board | Status | Completed | Blocked | Decision |
| --- | --- | ---: | ---: | --- |
| v0.36 build 12 TestFlight release proof | done | 3 | 0 | build 12 uploaded/valid/internal beta |
| v0.37 build 12 physical onboarding smoke | done | 3 | 0 | build 12 installed/smoked on iPhone-preview |
| v0.38 build 12 host-app matrix rerun | done | 4 | 0 | Safari pass, Notes/Messages exact privacy blockers |
| v0.39 build 12 tester handoff update | done | 3 | 0 | handoff/README updated to build 12 with caveats |

## PR State

`foil-ios`:

- Open PRs: none.
- Recent merged PRs:
  - #22: build 12 physical onboarding smoke
  - #23: build 12 host-app matrix rerun
  - #24: build 12 tester handoff update

`foil`:

- Open PR #285 is a draft: `[codex] Add live audio signifier design`.
- This appears unrelated to Foil iOS build 12 closed-beta readiness and is not a
  blocker for the iOS decision.

## Exact Blockers/Risks Carried Forward

- Notes build 12 rerun is blocked until a blank sterile Notes editor is opened
  or automated.
- Messages build 12 rerun is blocked until a direct sterile compose path works
  or an operator opens a sterile New Message compose with the body focused.
- Mail remains deferred under issue #12.
- These are not hidden board blockers; they are documented scope limits for the
  closed-beta recommendation.
