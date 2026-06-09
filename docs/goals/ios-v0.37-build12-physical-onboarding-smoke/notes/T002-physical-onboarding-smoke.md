# T002 Physical Onboarding Smoke

## Decision

`passed_physical_build12_onboarding_smoke`

## Device And Build

Physical target:

- device: `iPhone-preview`
- CoreDevice identifier: `5320F5AD-2A71-50AC-94FE-207B544B6247`
- hardware UDID: `00008030-001A0C980A33C02E`
- iOS: `26.5`
- WDA URL: `http://192.168.1.40:8100`

Installed app proof:

```text
Foil iOS                        com.neonwatty.FoilIOS                               0.1.0     12
```

## TestFlight Update Proof

TestFlight launched through CoreDevice, and WDA source showed:

- app title: `Foil Dictation`
- enabled update control: `TestFlight.offerButton.update`
- visible release metadata: `VERSION:0 . 1 . 0 Build 12`
- visible build label: `Build 12`

After tapping the update control through WDA, CoreDevice reported Foil iOS
bundle version `12` on the physical phone.

## Onboarding UI Proof

Foil iOS build 12 launched through CoreDevice and WDA source checks showed the
expected setup surface on the physical phone:

- visible top-level app title: `Foil iOS`
- visible closed beta setup card: `Closed beta setup`
- visible setup rows after scrolling:
  - `Provider key`
  - `Microphone`
  - `Add Foil Keyboard`
  - `Allow Full Access`
  - `Record in Foil`
  - `Return and insert`
  - `Reset when stale`
- visible target guidance after scrolling:
  - `Where to test`
  - `Safe targets`
  - `Messages draft only`
  - `Deferred targets`
  - `Narrow beta`
  - `Recovery`
- visible caveat copy:
  - `Use blank Notes, Safari normal text fields, or a Messages draft with safe test text.`
  - `Messages is for draft insertion testing only. Do not send test messages.`
  - `Mail is deferred, and Secure fields should reject Foil Keyboard.`
  - `This tests the record, return, and insert loop; it is not broad iPhone app support.`

## App Group Hygiene

The App Group snapshot copied back from the physical phone reported:

- phase: `idle`
- hasTranscript: `false`
- snapshot hash: `b897bba750bcc3cd1423029e739223789064c9fc78370a9b3a7d87c086d9dc64`

## Privacy Boundary

No raw WDA accessibility trees or screenshots were committed. Raw WDA source
files were stored only under `/tmp` during the run. The committed receipt stores
hashes, command names, build metadata, and boolean UI assertions only.
