# T001 Public Copy Inventory

## Scope

Inventory target repo: `/Users/neonwatty/Desktop/foil`.

The relevant public surfaces were:

- `site/index.html`
- `site/styles.css`
- `site/blog/wispr-flow-vs-superwhisper-vs-foil/index.html`
- `site/blog/superwhisper-alternative-for-mac/index.html`
- `site/blog/wispr-flow-alternative-for-mac/index.html`

## Findings

The landing page did not yet have a dedicated iPhone preview section. The best insertion point was after the screenshot/product-proof section and before the privacy/locality section, because the iOS preview is product status and evidence, not a new marketing hero.

Comparison blog copy had iOS references, but the Foil side needed a narrower, evidence-shaped description:

- Foil iOS is a closed iPhone preview, not a public iOS app.
- It uses a custom keyboard and requires Allow Full Access.
- Verified host-app rows are Notes blank editor insertion, Safari normal text fields, and Messages fake-recipient draft insertion without sending.
- Mail compose remains deferred.
- Secure fields should reject the custom keyboard.

The main repo had unrelated untracked files, but none touched the public-site files in this slice:

- `/Users/neonwatty/Desktop/foil/FoiliOS/`
- `/Users/neonwatty/Desktop/foil/docs/superpowers/plans/2026-06-03-foil-marketing-landing-page.md`

## Proposed Section Outline

Add an `#iphone-preview` landing-page section with:

- direct closed-beta status copy;
- a current iOS app screenshot from simulator proof;
- a short explanation of the keyboard-mediated dictation loop;
- a verified/deferred matrix;
- a CTA to the `mean-weasel/foil-ios` repository rather than a public availability claim.
