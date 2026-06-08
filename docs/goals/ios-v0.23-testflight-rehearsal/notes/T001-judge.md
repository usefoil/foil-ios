# T001 Judge

## Decision

Approve a command-mailbox TestFlight rehearsal slice.

## Rationale

The installed app metadata is already known from preflight and build 11 is on
the preview iPhone. WDA remains unavailable, but this board's app-side oracle
can still be tested with CoreDevice payload URLs:

- reset App Group state;
- launch `foilios://start`;
- play a sterile phrase;
- launch `foilios://stop`;
- launch `foilios://transcribe`;
- verify App Group `phase=complete`, `hasTranscript=true`.

This proves the installed build can produce a fresh transcript ready for the
keyboard. It does not prove keyboard insertion or host-app behavior.

## Approved Worker

T002 may write only this board's notes/receipts and may not upload, install,
replace, or change product code.
