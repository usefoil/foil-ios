# T004 Physical Smoke Receipt: Build 11

## Claim

The preview phone installed Foil iOS `0.1.0 (11)` from TestFlight and passed the
core physical live transcription plus Foil Keyboard insertion smoke on that
installed build.

## Strongest Realistic Failure Mode

The smoke could have run against the old build `10`, a debug install, or stale
shared transcript state instead of the newly installed TestFlight build `11`.

## Evidence

- TestFlight detail showed Foil Dictation `VERSION 0.1.0 Build 11`.
- The operator approved the TestFlight replacement prompt for the existing app.
- `devicectl device info apps` then reported `Foil iOS`,
  `com.neonwatty.FoilIOS`, version `0.1.0`, bundle version `11`.
- WDA was restored at `http://192.168.1.40:8100`.
- App Group was reset before the smoke and read back as `phase=idle`,
  `hasTranscript=false`.
- Foil app source receipt showed:
  - `Groq key configured`
  - `start-recording-button` present
  - recording state after tapping Record
  - saved recording and enabled Transcribe action after Stop
  - `Groq transcript ready` after Transcribe
- App Group after transcribe was `phase=complete`, `hasTranscript=true`, with
  transcript hash and length only recorded.
- Notes pre-insert receipt showed Foil Keyboard active and `Insert latest`
  enabled; existing sterile phrase count was `3`.
- WDA element-click on `foil-keyboard-insert-latest` inserted the latest
  transcript; Notes post-insert receipt showed phrase count `4` and `Insert
  latest` disabled.
- App Group after insert and final cleanup both read back `phase=idle`,
  `hasTranscript=false`.

## Attempt Notes

- A coordinate tap on the keyboard button did not activate insertion; the source
  hash and count stayed unchanged. The successful action used WDA element lookup
  by accessibility id followed by element click.
- Notes already contained prior sterile smoke text, so this receipt proves
  insertion by a count delta from `3` to `4`, not by a fresh empty note.

## Receipts

- `notes/receipts/build11-installed-metadata.json`
- `notes/receipts/build11-status-live.json`
- `notes/receipts/build11-app-group-before.json`
- `notes/receipts/build11-foil-before-record.json`
- `notes/receipts/build11-foil-after-record-start.json`
- `notes/receipts/build11-foil-after-record-stop.json`
- `notes/receipts/build11-foil-after-transcribe.json`
- `notes/receipts/build11-app-group-after-transcribe.json`
- `notes/receipts/build11-notes-before-insert.json`
- `notes/receipts/build11-notes-after-insert.json`
- `notes/receipts/build11-app-group-after-insert.json`
- `notes/receipts/build11-app-group-cleanup.json`

## Privacy Boundary

Raw WDA source stayed under `/tmp`. Committed receipts contain hashes, counts,
booleans, identifiers, state names, and lengths, not private note bodies,
screenshots, provider keys, or JWTs.
