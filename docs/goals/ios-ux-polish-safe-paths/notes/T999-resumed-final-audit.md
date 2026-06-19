# Resumed Final Audit

Result: complete.

The iOS UX polish tranche now has source-level proof from PR #50 and current-main physical proof on the preview iPhone. The previously blocked physical walkthrough was resumed after WDA recovery and user-prepared sterile host-app surfaces.

Evidence rules out the main failure mode: the app and keyboard do not claim ready/setup-complete while route/provider, Full Access, keyboard health, App Group state, exact-once insertion, or secure-field rejection are failing.

Sanitized evidence:

- `T015-current-main-route-visible-receipt.json`: route-first onboarding surface present with Use my Mac, iPhone API key, provider field, and dictation console identifiers.
- `T015-current-main-mac-route-not-ready-receipt.json`: Mac route remains explicitly not ready and does not overclaim setup completion.
- `T015-current-main-incomplete-setup-leads-layout.json`: incomplete idle setup leads the app before dictation.
- `T016-current-main-ready-after-keyboard-refresh-receipt.json`: iPhone API route, provider, Full Access, and recent keyboard health are ready after extension check-in.
- `T017-current-main-safari-before-insert-receipt.json` and `T017-current-main-safari-after-insert-receipt.json`: Safari sterile field inserts exactly once and disables repeat insertion.
- `T018-current-main-secure-field-rejection-receipt.json`: secure field rejects Foil Keyboard insertion support and leaves the sterile phrase absent.
- `T019-current-main-notes-before-insert-receipt.json` and `T019-current-main-notes-after-insert-receipt.json`: blank Notes editor inserts the sterile phrase exactly once and disables repeat insertion.
- `T020-current-main-messages-before-insert-receipt.json` and `T020-current-main-messages-after-insert-receipt.json`: user-prepared Messages draft inserts the sterile phrase exactly once and disables repeat insertion without sending.
- `T017-current-main-app-group-after-insert.json`, `T019-current-main-app-group-after-notes-insert.json`, and `T020-current-main-app-group-after-messages-insert.json`: App Group returns to idle with no transcript after insertion.

Privacy audit: receipts contain hashes, counts, booleans, identifier presence, and build/setup assertions only. Raw WDA trees stayed in `/tmp/foil-ios-ux-polish`; no screenshots, private phone content, provider keys, App Store Connect keys, JWTs, transcripts, archives, or IPAs are committed.
