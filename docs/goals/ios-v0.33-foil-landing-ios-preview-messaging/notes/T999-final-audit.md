# T999 Final Audit

## Strongest Realistic Failure Mode

The most realistic failure was that public copy would overclaim the iOS preview: implying a public iOS app, broad iPhone app support, Mail success, delivery in Messages, or arbitrary app support beyond the host-app matrix already tested.

## Evidence That Rules It Out

Merged main-site copy now uses bounded language:

- "closed internal beta"
- "custom keyboard"
- "not a public iOS app yet"
- "Allow Full Access"
- Notes/Safari/Messages fake-recipient draft as verified rows
- "Mail compose is deferred"
- "Secure fields should reject the custom keyboard"
- "not broad iPhone app support or public App Store availability"

Copy scan after merge found only expected iOS references:

- the new landing-page preview section;
- comparison-context rows that describe competitor public iOS apps;
- Foil caveats that explicitly say closed preview or not public yet;
- older macOS-only design docs that mention keyboard events, not iOS availability.

Browser proof shows the section is visible and does not create horizontal overflow:

- Desktop: `innerWidth` 1440, `documentScrollWidth` 1440, `bodyScrollWidth` 1440, `sectionOverflow` empty.
- Mobile: `innerWidth` 390, `documentScrollWidth` 390, `bodyScrollWidth` 390, `sectionOverflow` empty.

GitHub proof:

- PR #283: https://github.com/mean-weasel/foil/pull/283
- Merged: 2026-06-08T23:18:43Z
- Merge commit: `f8e83915111d505997b84ae27a2c4125f2e44b7b`
- CI result: changed-path detection and CI gate succeeded; app build/unit/UI jobs were skipped because this was a static-site-only slice.

## Decision

The v0.33 landing-page messaging board is complete. The main-site public copy now has a narrow, honest iPhone preview story with browser proof and merged PR evidence.
