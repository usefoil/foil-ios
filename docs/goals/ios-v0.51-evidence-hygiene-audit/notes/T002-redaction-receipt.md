# T002 Redaction Receipt

Result: done

Safe, non-destructive docs/receipt redactions were applied. The redactions keep
phase, message, length, short SHA-256, expected sterile markers, reset proof,
and artifact references while removing raw transcript and host-field bodies.

Files updated include legacy physical-dictation, preview-device, keyboard
prototype, target-app matrix, and useful-dictation GoalBuddy receipts.

Examples of preserved proof after redaction:

- complete App Group snapshots still record phase/message, `transcriptLength`,
  and `transcriptSha256`;
- insertion rows still record before/after metadata and idle/no-transcript
  reset evidence;
- weak or environmental audio results remain called out as weak/residual risk
  without preserving the raw body;
- deterministic fake transcript rows now use length/hash metadata instead of
  quoting the fake body.

No product code was changed.
