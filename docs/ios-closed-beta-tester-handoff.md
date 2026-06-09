# Foil iOS Closed Beta Tester Handoff

Audience: internal TestFlight testers for the Foil iOS preview.

## Build To Test

- App: Foil Dictation / Foil iOS
- Bundle ID: `com.neonwatty.FoilIOS`
- Current beta target: `0.1.0 (12)`
- Keyboard: Foil Keyboard
- Status: narrow internal beta for the app-to-keyboard dictation loop

## What This Beta Is For

Foil iOS lets you record in the Foil app, create a transcript, return to a text
field, switch to Foil Keyboard, and tap **Insert latest** once.

This beta is meant to test whether that loop feels understandable and reliable
in safe text fields.

## What Is Proven

- Build `0.1.0 (12)` is available to internal TestFlight testers.
- Build `0.1.0 (12)` installed on the preview iPhone and showed the closed-beta
  setup, target guidance, and recovery guidance.
- Build `0.1.0 (12)` inserted once into a Safari normal text field on a sterile
  local test page.
- Build `0.1.0 (12)` kept Foil Keyboard out of a Safari secure/password field,
  as expected.
- Earlier builds proved sterile Notes insertion and fake-recipient Messages
  draft insertion, but the build 12 rerun stopped before insertion when those
  apps did not open to sterile surfaces.

## Known Caveats

- This is not arbitrary iPhone app support.
- Mail compose is deferred: `https://github.com/mean-weasel/foil-ios/issues/12`.
- Notes and Messages are safe feedback targets only when you create a blank,
  non-private editor/draft first.
- Messages delivery and existing private-thread behavior are not claimed.
- Full Access is required so the keyboard can read and clear shared dictation
  state.
- You may need to cycle keyboards or refocus the target field before Foil
  Keyboard refreshes.
- Secure fields should not show Foil Keyboard. Treat that as expected behavior.

## Setup

1. Install or update Foil Dictation from TestFlight.
2. Open Foil once.
3. Save the provider key if the app asks for it.
4. Allow microphone access when prompted.
5. Open **Settings > General > Keyboard > Keyboards**.
6. Add **Foil Keyboard**.
7. Open **Foil Keyboard** and enable **Allow Full Access**.
8. Return to the target field, tap it again, cycle back to Foil Keyboard, then
   return to Foil and confirm Keyboard health is not blocked.

## Test Tasks

Use only non-private phrases, such as:

- `violet cactus number one`
- `silver compass number two`
- `green lantern number three`

### Notes

Use only a new blank note. Skip this task if Notes opens to existing content
that is not safe to edit.

1. Open a new blank note.
2. Tap the note body.
3. Switch to Foil Keyboard.
4. Tap **Dictate in Foil** or open Foil manually.
5. Record a short safe phrase.
6. Create the transcript.
7. Return to Notes and tap **Insert latest** once.
8. Confirm the text appears once.

### Safari

1. Open a blank/search text field or a safe test page.
2. Switch to Foil Keyboard.
3. Record/transcribe in Foil.
4. Return to Safari and tap **Insert latest** once.
5. Confirm the text appears once.

### Messages Draft

Use this only in a fake-recipient draft or a dedicated test thread with no
private history visible.

1. Create a new message draft to a fake/test recipient.
2. Do not send.
3. Focus the message body.
4. Switch to Foil Keyboard.
5. Record/transcribe in Foil.
6. Return to Messages and tap **Insert latest** once.
7. Confirm the draft body changed once.
8. Clear the draft instead of sending.

## Recovery

- If Foil Keyboard does not appear, tap the target field again and use
  globe/Next Keyboard to cycle back to Foil Keyboard.
- If Insert latest is disabled, open Foil and check Keyboard health.
- If Full Access is off, enable it in Keyboard settings, then refocus the target
  field and cycle back to Foil Keyboard.
- If the transcript is stale or wrong, use **Reset shared state** in Foil and
  record again.
- If recording or transcription fails, retry with a shorter phrase.

## Feedback Template

Please send:

- iPhone model and iOS version.
- TestFlight build number.
- Target app and field type: Notes, Safari, Messages draft, or other safe text
  field.
- Whether Full Access was enabled.
- Whether keyboard cycling/refocus was needed.
- Whether recording, transcription, insertion, and reset each worked.
- Whether text inserted exactly once.
- Which recovery step helped, if any.

Please do not send:

- private transcript text;
- screenshots of private messages, email, contacts, notes, accounts, or
  browser history;
- phone numbers, contact names, account names, or private app content.

## Safe Claim

Foil iOS build `0.1.0 (12)` is ready for narrow internal feedback on the
record-in-Foil, return-to-keyboard, Insert-latest loop in safe text fields. The
build 12 physical matrix currently proves Safari normal insertion and Safari
secure-field rejection; Notes and Messages remain tester feedback targets only
when the tester can create a blank, non-private note or draft.

## Unsafe Claims

Do not claim broad iPhone app compatibility, Mail support, Messages delivery,
or safe use inside existing private threads.
