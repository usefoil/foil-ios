# T001 Evidence Hygiene Audit Receipt

Result: findings_requires_redaction

The tracked media inventory contains only app icons plus four simulator/landing
screenshots. No tracked `.mov` or `.mp4` files were found.

Commands:

- `git ls-files | rg '\.(mov|mp4|png|jpe?g)$' | sort`
- `rg -n '<XCUIElementType|AppiumAUT|wdValue|WebDriverAgent source|raw WDA|/source' docs .github README.md scripts FoiliOS --glob '!docs/goals/ios-v0.51-evidence-hygiene-audit/**' || true`
- `rg -n 'gsk_|Bearer |Authorization|-----BEGIN|PRIVATE KEY|APP_STORE|issuer id|key id|api[_ -]?key|provider key|credentials' . --glob '!FoiliOS/FoilIOSTests/**' --glob '!docs/goals/ios-v0.51-evidence-hygiene-audit/**' || true`
- `rg -n 'broad iPhone|arbitrary app|Mail support|Messages delivery|existing private|secure-field support|ready for closed beta|invite_closed_beta|Go, narrow|narrow internal|not broad|not arbitrary|deferred|privacy blocked|blocked, not rerun' docs README.md .github || true`
- `rg -n '("transcript"\s*:|^\s*transcript:|inserted_transcript:|safe_transcript:|expected_transcript:|before_value:|after_value:)' docs/goals docs/ios-keyboard-host-app-matrix.md README.md .github scripts --glob '!docs/goals/ios-v0.51-evidence-hygiene-audit/**' --glob '!docs/goals/**/.goalbuddy-board/**'`

Findings:

- Legacy physical-dictation receipts preserved raw transcript bodies, including
  at least one environmental pickup before an intended sterile phrase.
- Some older matrix/prototype receipts preserved deterministic fake transcript
  and host-field values instead of metadata.
- WDA/source and secret scans found policy prose, scripts, placeholders, and
  code templates, but no committed raw WDA source file, private-key block,
  Groq-style secret value, JWT, or provider/App Store credential.
- Claim scan found current anti-claims and bounded narrow-beta language:
  arbitrary app support is not claimed, Mail remains deferred, Messages
  delivery/private-thread behavior is not claimed, and build-specific blockers
  remain labeled.

Action: T002 should safely redact legacy transcript/host-field bodies to
length/hash metadata while preserving proof value.
