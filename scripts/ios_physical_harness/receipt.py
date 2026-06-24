"""Sanitized receipt and fixture-only self-test commands."""

from __future__ import annotations

import json
import sys
import tempfile
from pathlib import Path

from .app_group import snapshot_payload, summarize_snapshot_path
from .common import run_command, sanitized_process_result, short_hash, write_json
from .constants import EVIDENCE_HELPER


def cmd_receipt(args) -> int:
    helper_args = [
        sys.executable,
        str(EVIDENCE_HELPER),
        "--source",
        str(args.source),
        "--target",
        args.target,
    ]
    for option_name, values in [
        ("--require-identifier", args.require_identifier),
        ("--forbid-identifier", args.forbid_identifier),
        ("--expect-identifier-state", args.expect_identifier_state),
        ("--require-value", args.require_value),
        ("--forbid-value", args.forbid_value),
        ("--require-text", args.require_text),
        ("--forbid-text", args.forbid_text),
        ("--expect-value-count", args.expect_value_count),
    ]:
        for value in values:
            helper_args.extend([option_name, value])
    if args.app_group_snapshot:
        helper_args.extend(["--app-group-snapshot", str(args.app_group_snapshot)])
    if args.storage_report:
        helper_args.extend(["--storage-report", str(args.storage_report)])
    if args.write_json:
        helper_args.extend(["--write-json", str(args.write_json)])
    result = run_command(helper_args, timeout=30)
    if args.write_json:
        write_json(
            {
                "schema": "foil.iosPhysicalHarness.receipt.v1",
                "helper": str(EVIDENCE_HELPER),
                "returncode": result.returncode,
                "writeJson": str(args.write_json),
                "stdoutBytes": len(result.stdout.encode("utf-8")),
                "stderrSha256": short_hash(result.stderr) if result.stderr else None,
            }
        )
    else:
        print(result.stdout, end="")
        if result.stderr:
            print(result.stderr, file=sys.stderr, end="")
    return result.returncode


def run_helper_for_self_test(source: Path, *extra_args: str):
    return run_command(
        [
            sys.executable,
            str(EVIDENCE_HELPER),
            "--source",
            str(source),
            "--target",
            "self-test",
            *extra_args,
        ],
        timeout=30,
    )


def cmd_self_test(_) -> int:
    secret_phrase = "Foil harness self test phrase"
    raw_xml = (
        '<AppiumAUT>'
        '<XCUIElementTypeOther name="foil-keyboard-root" enabled="true" />'
        '<XCUIElementTypeButton name="foil-keyboard-insert-latest" enabled="false" />'
        f'<XCUIElementTypeTextView value="{secret_phrase}" />'
        "</AppiumAUT>"
    )
    with tempfile.TemporaryDirectory(prefix="foil-ios-harness-self-test-") as temp_dir:
        temp = Path(temp_dir)
        source = temp / "source.json"
        source.write_text(json.dumps({"value": raw_xml}), encoding="utf-8")
        passing = run_helper_for_self_test(
            source,
            "--require-identifier",
            "foil-keyboard-root",
            "--expect-identifier-state",
            "foil-keyboard-insert-latest.enabled=false",
            "--expect-value-count",
            f"{secret_phrase}=1",
        )
        failing = run_helper_for_self_test(source, "--expect-value-count", f"{secret_phrase}=2")
        complete_snapshot = temp / "complete.json"
        idle_snapshot = temp / "idle.json"
        complete_snapshot.write_text(
            json.dumps(snapshot_payload("complete", secret_phrase, "Fake transcript ready")),
            encoding="utf-8",
        )
        idle_snapshot.write_text(json.dumps(snapshot_payload("idle", None, "Ready")), encoding="utf-8")
        complete_summary = summarize_snapshot_path(complete_snapshot)
        idle_summary = summarize_snapshot_path(idle_snapshot)
        encoded_summaries = json.dumps({"complete": complete_summary, "idle": idle_summary})
        no_raw_transcript = secret_phrase not in passing.stdout and secret_phrase not in encoded_summaries
        checks = [
            {"name": "evidence-helper-passes-good-expectations", "passed": passing.returncode == 0},
            {"name": "evidence-helper-fails-bad-count", "passed": failing.returncode != 0},
            {"name": "summaries-omit-raw-transcript", "passed": no_raw_transcript},
            {
                "name": "complete-summary-has-transcript-hash",
                "passed": complete_summary.get("hasTranscript") is True
                and "transcriptHash" in complete_summary
                and "transcript" not in complete_summary,
            },
            {
                "name": "idle-summary-has-no-transcript",
                "passed": idle_summary.get("hasTranscript") is False and "transcriptHash" not in idle_summary,
            },
        ]
        receipt = {
            "schema": "foil.iosPhysicalHarness.selfTest.v1",
            "checks": checks,
            "passed": all(check["passed"] for check in checks),
            "passingHelper": sanitized_process_result(passing),
            "failingHelper": sanitized_process_result(failing),
            "completeSummary": complete_summary,
            "idleSummary": idle_summary,
        }
        write_json(receipt)
        return 0 if receipt["passed"] else 1
