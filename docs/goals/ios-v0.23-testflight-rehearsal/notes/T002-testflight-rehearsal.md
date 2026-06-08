# T002 TestFlight Rehearsal

## Claim

Installed Foil iOS `0.1.0 (11)` on `iPhone-preview` can produce a fresh sterile
transcript ready for Foil Keyboard insertion.

## Strongest Realistic Failure Mode

The receipt could be from a stale transcript or the wrong build rather than the
currently installed TestFlight build.

## Evidence

- Installed app metadata reports `com.neonwatty.FoilIOS`, version `0.1.0`,
  bundle version `11`.
- App Group was reset before recording and read back as `idle`,
  `hasTranscript=false`.
- CoreDevice payload URLs launched the installed app with `foilios://start`,
  `foilios://stop`, and `foilios://transcribe`.
- A sterile phrase was played while the phone recorded.
- After transcribe, App Group reported `phase=complete`, `hasTranscript=true`,
  transcript hash `1210c267a9cf2826`, and transcript length `87`.
- The transcript was intentionally left staged for the keyboard.

## Receipt

- `notes/receipts/build-installed.json`
- `notes/receipts/command-mailbox-rehearsal.json`

## Residual Risk

WDA is still unavailable, so this board proves app-side TestFlight
record/transcribe only. It does not prove keyboard insertion into Apple host
apps.
