# T007 Final TestFlight Readiness Audit

Verdict: ready for internal TestFlight smoke.

Strongest false-ready mode: build 13 could be uploaded and attached in App
Store Connect, but the preview phone could still be running a stale developer
install or could say setup is ready while keyboard health, Full Access, App
Group state, or provider route is not actually healthy.

Evidence that rules it out:

- T001: issue #39 is closed and the route-first physical proof board validates
  done with T019/T020 receipts present.
- T002: archive/export regenerated under `/tmp`; IPA metadata is app and
  keyboard version `0.1.0 (13)`, with required icon outputs present.
- T003/T004: App Store Connect validation and upload succeeded for the same
  IPA hash.
- T005: App Store Connect processing is `VALID`, export compliance is cleared,
  build 13 is attached to `Foil Internal Testers`, and buildBetaDetails reports
  `IN_BETA_TESTING`.
- T006: strict preflight recovered to healthy via direct WDA URL
  `http://192.168.1.40:8100`.
- T006: TestFlight Foil detail showed Foil Dictation with Install available,
  then a replace confirmation, then Open with no visible account/password
  blocker.
- T006: tapping Open from the Foil-specific TestFlight detail launched
  `com.neonwatty.FoilIOS`.
- T006: the first post-TestFlight readiness check failed because Foil Keyboard
  had not checked in recently; this confirms onboarding did not falsely claim
  setup complete.
- T006: cycling Foil Keyboard through the sterile Safari normal field refreshed
  keyboard health, and the final Foil receipt passed with `onboarding-ready`
  present, `onboarding-not-ready` absent, Full Access ready text present by
  hash, and stale/Full Access-off warnings absent.
- T006: final App Group summary is `phase=idle` and `hasTranscript=false`.

Residual risks:

- CoreDevice continued to report `builtByDeveloper=true` after the TestFlight
  replace. This metadata was not used as the source-of-install oracle; the
  stronger proof is the Foil-specific TestFlight Install/Replace/Open flow plus
  active-app and readiness receipts.
- This pass proves internal TestFlight readiness and one sterile physical smoke.
  It does not broaden the target-app insertion matrix beyond the already
  accepted issue #39 physical proof.

Privacy audit:

- No provider key, App Store Connect key, issuer value, private key, JWT, raw
  WDA tree, private phone screenshot, transcript body, IPA, or archive artifact
  is committed in this receipt.
