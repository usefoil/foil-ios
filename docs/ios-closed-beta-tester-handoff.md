# Foil iOS Closed Beta Tester Handoff

Audience: internal TestFlight testers for the Foil iOS preview.

## Build To Test

- App: Foil Dictation / Foil iOS
- Bundle ID: `com.neonwatty.FoilIOS`
- Current beta target: `0.1.0 (11)`
- Keyboard: Foil Keyboard
- Status: narrow internal beta for the app-to-keyboard dictation loop

## What This Beta Is For

Foil iOS lets you record in the Foil app, create a transcript, return to a text
field, switch to Foil Keyboard, and tap **Insert latest** once.

This beta is meant to test whether that loop feels understandable and reliable
in safe text fields.

## What Is Proven

- Foil can record/transcribe on the installed build and stage text for the
  keyboard.
- Foil Keyboard can insert once into a sterile Notes editor.
- Foil Keyboard can insert once into a Safari normal text field.
- Safari secure/password fields reject the custom keyboard as expected.
- Messages draft insertion is proven only in a fake-recipient compose draft, and
  no message was sent.

## Known Caveats

- This is not arbitrary iPhone app support.
- Mail compose is deferred: `https://github.com/mean-weasel/foil-ios/issues/12`.
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
8. Return to Foil and confirm Keyboard health is not blocked.

## Test Tasks

Use only non-private phrases, such as:

- `violet cactus number one`
- `silver compass number two`
- `green lantern number three`

### Notes

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

- If Foil Keyboard does not appear, cycle keyboards and tap the target field
  again.
- If Insert latest is disabled, open Foil and check Keyboard health.
- If Full Access is off, enable it in Keyboard settings, then reopen the target
  field.
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

Foil iOS build `0.1.0 (11)` is ready for narrow internal feedback on the
record-in-Foil, return-to-keyboard, Insert-latest loop in safe text fields.

## Unsafe Claims

Do not claim broad iPhone app compatibility, Mail support, Messages delivery,
or safe use inside existing private threads.
