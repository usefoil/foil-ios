# T001 Direct URL Recovery

## Result

`recovered_for_matrix`

## Evidence

- WDA printed `ServerURLHere->http://192.168.1.40:8100<-ServerURLHere`.
- `curl http://192.168.1.40:8100/status` returned ready JSON.
- `scripts/ios-physical-harness.py status --wda-url http://192.168.1.40:8100`
  reported `wda.ready=true`.
- A WDA session was created.
- A current Foil app source fetch succeeded and was kept in `/tmp`; only its
  hash/counts were recorded.
- A safe WDA tap command against the Foil-owned surface returned success.

## Decision

Use the direct `ServerURLHere` URL for physical UI automation unless a localhost
tunnel is explicitly active. Host-app insertion remains the next proof; this
receipt only proves the automation bridge.
