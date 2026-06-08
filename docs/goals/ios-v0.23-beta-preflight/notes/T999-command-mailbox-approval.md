# T999 Command-Mailbox Approval

## Decision

Approve a narrow command-mailbox preflight slice.

## Why

WDA remains unavailable, but CoreDevice can launch Foil iOS with a
`--payload-url`. The app already handles sterile URL commands:

- `foilios://reset`
- `foilios://start`
- `foilios://stop`
- `foilios://transcribe`

This does not replace WDA for host-app insertion, keyboard UI inspection, or
Apple app matrix proof. It can, however, verify the two preflight fields still
missing after T001/T002: current microphone permission and provider/key
readiness. If start/stop/transcribe produce a fresh complete App Group
transcript from a sterile spoken phrase, both fields are proven enough to
continue to the TestFlight rehearsal planning gate.

## Guardrails

- Use only sterile speech.
- Reset App Group state before starting.
- Do not print or commit the transcript body; record hashes, length, phase, and
  pass/fail assertions only.
- Stop if a device permission prompt, lock, install action, credential prompt,
  or non-sterile screen/content appears.
- Keep WDA marked unavailable; this slice does not unblock host-app matrix work.
