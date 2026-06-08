# T002 Copy Scan

## Commands

Current iOS-facing docs/app scan:

```bash
rg -n -i "build 7|Messages[^\n]{0,80}not tested|not tested[^\n]{0,80}Messages|Mail[^\n]{0,80}(pass|passed|works|verified|tested|success)|arbitrary[^\n]{0,40}(app|iOS)|any app|all apps|works everywhere|public[^\n]{0,40}iOS|iOS[^\n]{0,40}public|App Store|deliver(ed|y)" README.md docs/ios-closed-beta-tester-handoff.md docs/ios-keyboard-host-app-matrix.md docs/ios-testflight-feedback-v0.7.md FoiliOS --glob '!**/*.png' --glob '!**/*.jpg'
```

Current main-site/source scan:

```bash
rg -n -i "iOS app in progress|public claims should follow|Messages[^\n]{0,80}not tested|not tested[^\n]{0,80}Messages|Mail[^\n]{0,80}(pass|passed|works|verified|tested|success)|arbitrary[^\n]{0,40}(app|iOS)|any app|all apps|works everywhere|public[^\n]{0,40}iOS|iOS[^\n]{0,40}public|App Store" site/index.html site/blog/*/index.html docs/seo docs/product README.md
```

Private media scan over current onboarding/messaging boards:

```bash
find docs/goals/ios-v0.31-closed-beta-tester-handoff docs/goals/ios-v0.32-ios-app-onboarding-polish docs/goals/ios-v0.33-foil-landing-ios-preview-messaging docs/goals/ios-v0.34-onboarding-messaging-final-audit -type f \( -iname '*.mov' -o -iname '*.mp4' -o -iname '*ScreenRecording*' \) -print
```

## Classification

Expected iOS repo hits:

- `docs/ios-testflight-feedback-v0.7.md` still mentions build 7 and untested Messages, but the file begins with a superseded notice pointing testers to `docs/ios-closed-beta-tester-handoff.md`.
- `README.md`, `docs/ios-closed-beta-tester-handoff.md`, and `docs/ios-keyboard-host-app-matrix.md` contain anti-claims: no arbitrary app support, no Messages delivery/private-thread claim, Mail deferred, and draft-only Messages proof.

Expected main repo hits:

- competitor public iOS rows remain comparison context.
- Foil copy says closed iPhone preview, custom keyboard, Full Access, verified host-app rows, Mail deferred, and not public App Store availability.
- `works everywhere` appears only as a quoted claim to avoid.
- product docs say "iOS keyboard works everywhere" only inside a "Claims to avoid" list.

Private media scan result:

- No `.mov`, `.mp4`, or `ScreenRecording*` artifacts are present under the current onboarding/messaging board directories.

## Source-Doc Cleanup

The first final scan found stale main-repo source markdown that still said
"iOS app in progress". That was fixed and merged in PR #284 before this final
audit was closed.

## Decision

All scan hits are expected caveats, historical superseded context, competitor
comparison context, or explicit anti-claims. No current public/tester copy claims
Mail support, Messages delivery, broad arbitrary-app compatibility, or public
iOS availability for Foil.
