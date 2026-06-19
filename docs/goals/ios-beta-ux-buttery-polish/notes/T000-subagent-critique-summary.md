# Subagent Critique Summary

Three independent read-only UX critics reviewed the current Foil iOS app:

- Critic A: first-run route choice, Full Access, provider route, and setup-complete overclaim risk.
- Critic B: Foil Keyboard and host-app insertion flow.
- Critic C: end-to-end beta readiness, recovery, docs drift, and tester handoff.

Converged findings:

1. No P0 false-completion bug was found in current source/receipts for Mac route, Advanced route, Full Access, keyboard health, secure-field rejection, or exact-once insertion.
2. The highest UX risk is human flow continuity: the user must leave the target app, record in Foil, return manually, switch back to Foil Keyboard, then tap Insert latest once.
3. The second highest UX risk is route mismatch: the app defaults to the future Mac route while the beta docs tell testers to use the iPhone API-key route.
4. Provider readiness is currently key-presence based; copy should avoid implying the provider has been live-verified until it has.
5. Keyboard and recovery states are safe but too terse for confused beta testers.
6. Safe target guidance should be visible near ready/recovery states, while diagnostics and fake transcript tools remain behind Advanced / Support.
7. README and feedback template build examples still mention build 12 while the current tester handoff says build 13.

Preserve:

- Exact-once insertion and App Group idle recovery.
- Mac route and Advanced route never completing setup in this build.
- Secure-field rejection.
- Privacy-clean receipts using hashes, counts, booleans, and identifier presence only.

