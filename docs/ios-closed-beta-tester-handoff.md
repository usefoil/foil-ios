# Foil iOS Closed Beta Tester Handoff

Audience: internal TestFlight testers for the Foil iOS preview.

## Build To Test

- App: Foil Dictation / Foil iOS
- Bundle ID: `com.neonwatty.FoilIOS`
- Current beta target: `0.1.0 (13)`
- Keyboard: Foil Keyboard
- Status: narrow internal beta for the app-to-keyboard dictation loop

## What This Beta Is For

Foil iOS lets you record in the Foil app, create a transcript, return to a text
field, switch to Foil Keyboard, and tap **Insert latest** once.

This beta is meant to test whether that loop feels understandable and reliable
in safe text fields.

## What Is Proven

- Build `0.1.0 (13)` is uploaded, processed, export-compliance cleared, and
  attached to the internal TestFlight group.
- Build `0.1.0 (13)` installed from the Foil-specific TestFlight detail page on
  the preview iPhone, replaced the existing install, and launched Foil.
- Build `0.1.0 (13)` does not call setup complete while Foil Keyboard health is
  stale. After a keyboard refresh in a sterile Safari field, Foil reports setup
  ready and the shared App Group state is idle with no transcript.
- The route-first physical proof for issue #39 proved one exact insertion into
  a sterile Safari normal text field, then disabled Insert latest and returned
  shared state to idle/no transcript.
- Issue #39 also proved the API-key route, Full Access readiness, recent
  keyboard health, and App Group recovery on the physical preview iPhone.

## Known Caveats

- This is not arbitrary iPhone app support.
- Mail compose is deferred: `https://github.com/usefoil/foil-ios/issues/12`.
- Notes and Messages are safe feedback targets only when you create a blank,
  non-private editor/draft first.
- Messages delivery and existing private-thread behavior are not claimed.
- **Use my Mac** is the recommended future path, but Mac pairing is not the
  tester path yet.
- **Use an API key on this iPhone** is fully usable today. Testers who are asked
  to run the current beta should use this path unless they are explicitly
  testing Mac pairing copy.
- Full Access is required so Foil Keyboard can read and clear Foil's shared
  transcript state. It does not make secure/password fields available to Foil.
- You may need to cycle keyboards or refocus the target field before Foil
  Keyboard refreshes.
- Secure fields should not show Foil Keyboard. Treat that as expected behavior.

## Setup

1. Install or update Foil Dictation from TestFlight.
2. Open Foil once.
3. On **Choose your setup route**, prefer **Use an API key on this iPhone** for
   this beta. **Use my Mac** is recommended for the future Mac-pairing route but
   is not the current tester path.
4. Save the provider key if the app asks for it. Do not share this key in
   feedback.
5. Allow microphone access when prompted.
6. Open **Settings > General > Keyboard > Keyboards**.
7. Add **Foil Keyboard**.
8. Open **Foil Keyboard** and enable **Allow Full Access**.
9. Return to Foil.
10. Verify keyboard health:
    - If Foil says **Keyboard health** is ready, continue.
    - If Foil says Foil Keyboard has not checked in recently, open a safe text
      field, switch to Foil Keyboard, then return to Foil.
    - If Foil says Full Access is off, return to Keyboard settings, enable
      Allow Full Access, then reopen a safe text field with Foil Keyboard.

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
5. If Foil says keyboard health is stale, cycle away from and back to Foil
   Keyboard before recording.
6. Record a short safe phrase.
7. If you started with the wrong phrase or noisy audio, tap **Cancel** and
   record again.
8. Create the transcript.
9. Return to Notes and tap **Insert latest** once.
10. Confirm the text appears once.

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
- If Insert latest is disabled, open Foil and check Keyboard health. If it says
  the keyboard has not checked in recently, tap a safe target field, cycle back
  to Foil Keyboard, then return to Foil.
- If Full Access is off, enable it in Keyboard settings, then refocus the target
  field and cycle back to Foil Keyboard.
- If you start recording the wrong phrase or background noise, tap **Cancel**
  before creating a transcript and record again.
- If the transcript is stale or wrong, use **Reset shared state** in Foil and
  record again.
- If Foil says the provider key is missing or rejected, update the provider key
  in Foil before retrying transcription. Do not include the key in feedback.
- If Foil says processing may be stuck, retry transcription if the recording is
  still saved, or use **Reset shared state** before recording again.
- If Foil says App Group storage or verification failed, use **Reset shared
  state**, then confirm Shared state returns to **Ready, no transcript**.
- If recording or temporary transcription fails, retry with a shorter phrase.

## Feedback Template

Please use the GitHub **iOS beta feedback** issue form when available. It asks
for the same safe details below without collecting private content.

Please include:

- iPhone model and iOS version.
- TestFlight build number.
- Setup route used: **Use my Mac**, **Use an API key on this iPhone**, or
  **Advanced / Support**.
- Target app and field type: Notes, Safari, Messages draft, or other safe text
  field.
- Whether Foil showed Keyboard health ready before recording.
- Whether Full Access was enabled.
- Whether keyboard cycling/refocus was needed.
- Whether recording, transcription, insertion, App Group recovery, and reset
  each worked.
- Whether text inserted exactly once.
- Which recovery step helped, if any.

Please do not send:

- private transcript text;
- screenshots of private messages, email, contacts, notes, accounts, or
  browser history;
- phone numbers, contact names, account names, or private app content.

If a target app opens to private content, stop that task and report only that
the surface was not sterile.

## Safe Claim

Foil iOS build `0.1.0 (13)` is ready for narrow internal feedback on the
route-first setup, record-in-Foil, return-to-keyboard, Insert-latest loop in
safe text fields. The current physical gate proves TestFlight install/replace,
Foil launch, stale-keyboard blocking, keyboard-health recovery, provider route
readiness, App Group idle/no-transcript recovery, and exact-once Safari
insertion from issue #39. Notes and Messages remain tester feedback targets only
when the tester can create a blank, non-private note or draft.

## Unsafe Claims

Do not claim broad iPhone app compatibility, Mail support, Messages delivery,
or safe use inside existing private threads.
