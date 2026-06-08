# T002 Landing Worker

## Implementation

Implemented in the main Foil repo branch:

- Repo: `/Users/neonwatty/Desktop/foil`
- Branch: `codex/ios-preview-landing-messaging`
- Commit: `ccc9587 Add iOS preview messaging to landing page`
- PR: https://github.com/mean-weasel/foil/pull/283
- Merge commit: `f8e83915111d505997b84ae27a2c4125f2e44b7b`

Changed public-site files:

- `site/index.html`
- `site/styles.css`
- `site/assets/screenshots/foil-ios-onboarding-preview.jpg`
- `site/blog/wispr-flow-vs-superwhisper-vs-foil/index.html`
- `site/blog/superwhisper-alternative-for-mac/index.html`
- `site/blog/wispr-flow-alternative-for-mac/index.html`

## User-Facing Copy Boundaries

The landing page now states that Foil for iPhone is a closed internal beta using a custom keyboard, not a public iOS app yet.

It explicitly names the setup constraint:

- install Foil Keyboard;
- enable Allow Full Access;
- record in the Foil app;
- return to the host app and insert through the keyboard.

It explicitly names the verified/deferred host-app matrix:

- verified: Notes blank editor insertion;
- verified: Safari normal text fields;
- verified: Messages fake-recipient draft insertion, without sending;
- deferred: Mail compose;
- caveat: secure fields should reject the custom keyboard.

The CTA goes to the `mean-weasel/foil-ios` repo as "Follow iOS preview work" and does not claim App Store availability.

## Verification

Browser proof receipt:

- `notes/receipts/browser-proof.json`
- `notes/receipts/landing-ios-preview-desktop.png`
- `notes/receipts/landing-ios-preview-mobile.png`

Static/site proof from `/Users/neonwatty/Desktop/foil`:

- `git diff --check` passed before commit.
- Python HTML parser found no missing anchors or image references and confirmed `iphone-preview` exists.
- Browser proof passed on desktop width 1440 and mobile width 390.
- Desktop and mobile page scroll widths matched viewport widths, and `sectionOverflow` was empty for the iPhone preview section.
- PR #283 merged through the repository merge queue on 2026-06-08 at 23:18:43Z.
