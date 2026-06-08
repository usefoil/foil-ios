# T999 Final Audit

## Verdict

`go_after_fresh_testflight_build_and_narrow_physical_smoke`

The onboarding/messaging conveyor is complete for copy, docs, and local/simulator
app proof. The next closed-beta action should be to upload a fresh TestFlight
build that contains the v0.32 onboarding polish, then run a narrow physical
smoke on iPhone-preview before widening tester access.

## Strongest Realistic Failure Mode

The strongest realistic failure is that we invite testers using copy that sounds
ready, but the installed TestFlight build does not actually contain the polished
in-app onboarding/setup surface from v0.32.

## Evidence

Evidence that messaging is internally consistent:

- v0.31 tester handoff board is done and current handoff targets build `0.1.0 (11)` with Mail deferred, Messages draft-only, Full Access, keyboard cycling/refocus, secure-field rejection, and no arbitrary app claims.
- v0.32 onboarding polish board is done with presenter tests, full iOS tests, simulator build, and simulator screenshots.
- v0.33 landing-page messaging board is done; main Foil PR #283 merged the bounded iPhone preview section and browser proof.
- Main Foil PR #284 merged source-doc cleanup for stale "iOS app in progress" language.
- Open PR count is 0 in both repos.
- Cross-repo scans found no current overbroad Foil iOS public/tester claim.

Evidence that the remaining release action is a build/smoke step:

- `FoiliOS/project.yml` still declares `MARKETING_VERSION: 0.1.0` and `CURRENT_PROJECT_VERSION: 11`.
- `docs/goals/ios-v0.32-ios-app-onboarding-polish/notes/T999-final-audit.md` explicitly says the onboarding polish has local simulator proof only and should be verified in a future TestFlight build on the physical preview iPhone before widening beta access.

## Recommendation

Next owner/action:

- Codex should prepare and run the next GoalBuddy board for a fresh TestFlight upload, likely build `0.1.0 (12)`, containing the v0.32 onboarding polish.
- After upload/install on iPhone-preview, run the narrow smoke matrix: app setup surface visible, provider/microphone/keyboard/Full Access guidance readable, Notes insertion, Safari normal-field insertion, Messages fake-recipient draft insertion without sending, secure-field rejection, and App Group idle/no transcript after insert/reset.
- Update the tester handoff build number only after the new build is uploaded and physically smoke-tested.

Accepted caveats:

- Mail compose remains deferred: https://github.com/mean-weasel/foil-ios/issues/12.
- No broad iPhone app support, no public App Store claim, no Messages delivery claim, and no existing private-thread behavior claim.

## Decision

The onboarding/messaging prep boards are burned down. The closed-beta copy is
ready, but the next practical release step is build/upload/physical-smoke rather
than widening testers on stale app bits.
