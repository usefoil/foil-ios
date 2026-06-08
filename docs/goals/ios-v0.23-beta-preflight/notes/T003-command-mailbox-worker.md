# T003 Command-Mailbox Worker

## Claim

Current provider/key readiness and microphone permission are proven without WDA
by using Foil iOS sterile payload URL commands on the installed preview phone.

## Strongest Realistic Failure Mode

The app might launch, but recording or provider transcription could fail because
microphone permission is denied, the Groq key is missing, the previous transcript
is stale, or cleanup does not return the keyboard bridge to idle.

## Evidence

- Reset before the run returned App Group state to `idle`, `hasTranscript=false`.
- CoreDevice launched `com.neonwatty.FoilIOS` with:
  - `foilios://start`
  - `foilios://stop`
  - `foilios://transcribe`
- The Mac played a sterile phrase while the phone was recording.
- After transcribe, App Group summary reported `phase=complete`,
  `hasTranscript=true`, transcript hash `536497e17315e770`, and transcript
  length `75`.
- Final cleanup returned App Group state to `idle`, `hasTranscript=false`.

## Receipt

- `notes/receipts/command-mailbox-proof.json`

## Residual Risk

WDA remains unavailable. This proof does not verify host-app insertion, keyboard
button state, Messages/Mail/Safari UI behavior, or tester-visible recovery UX.
It only closes the provider/key and microphone preflight gap.
