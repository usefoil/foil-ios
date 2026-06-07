# T999 Final Audit: v0.22 TestFlight Release Proof

## Decision

Complete.

## Strongest Realistic Failure Mode

The release proof could accidentally combine App Store Connect build `11`
metadata with a physical smoke that actually ran against build `10`, a debug
install, or stale App Group state.

## Evidence That Rules It Out

- Source metadata and exported IPA both showed app and keyboard version
  `0.1.0`, build `11`.
- App Store Connect accepted delivery
  `12ba179e-cc4d-4685-920f-ccc3bc916fa9`, reported the build `VALID`, and
  listed it in `Foil Internal Testers`.
- TestFlight presented Foil Dictation `VERSION 0.1.0 Build 11`.
- After the operator approved replacement, device metadata reported
  `com.neonwatty.FoilIOS` version `0.1.0`, bundle version `11`.
- The live smoke launched `com.neonwatty.FoilIOS` after the installed-build
  metadata check.
- The smoke began from an App Group reset/readback of `phase=idle`,
  `hasTranscript=false`.
- The app control path created a fresh provider-backed complete transcript, with
  the transcript represented only by hash and length.
- The keyboard proof inserted through `foil-keyboard-insert-latest`, increased
  the sterile phrase count from `3` to `4`, disabled Insert latest, and returned
  App Group state to `idle` with no transcript.

## Residual Risk

This final smoke proves Notes insertion only. Broader host-app matrix coverage
remains in the earlier target-app boards and future beta-hardening work.
