"""App Group snapshot staging and redacted summary commands."""

from __future__ import annotations

import json
import tempfile
import time
from pathlib import Path
from typing import Any

from .common import HarnessError, run_command, sanitized_process_result, sha256_text, short_hash, write_json
from .constants import APP_GROUP_ID, SNAPSHOT_PATH, SWIFT_DATE_OFFSET


def snapshot_payload(phase: str, transcript: str | None, message: str) -> dict[str, Any]:
    return {
        "phase": phase,
        "transcript": transcript,
        "message": message,
        "updatedAt": time.time() - SWIFT_DATE_OFFSET,
    }


def summarize_snapshot_path(path: Path) -> dict[str, Any]:
    raw = path.read_text(encoding="utf-8")
    payload = json.loads(raw)
    transcript = payload.get("transcript")
    message = payload.get("message")
    summary: dict[str, Any] = {
        "file": path.name,
        "sha256": sha256_text(raw),
        "phase": payload.get("phase"),
        "hasTranscript": bool(transcript),
    }
    if isinstance(message, str):
        summary["messageHash"] = short_hash(message)
    if isinstance(transcript, str) and transcript:
        summary["transcriptHash"] = short_hash(transcript)
        summary["transcriptLength"] = len(transcript)
    return summary


def copy_snapshot_to_device(source: Path, device_id: str):
    return run_command(
        [
            "xcrun",
            "devicectl",
            "device",
            "copy",
            "to",
            "--device",
            device_id,
            "--domain-type",
            "appGroupDataContainer",
            "--domain-identifier",
            APP_GROUP_ID,
            "--source",
            str(source),
            "--destination",
            SNAPSHOT_PATH,
        ],
        timeout=60,
    )


def copy_snapshot_from_device(destination: Path, device_id: str):
    return run_command(
        [
            "xcrun",
            "devicectl",
            "device",
            "copy",
            "from",
            "--device",
            device_id,
            "--domain-type",
            "appGroupDataContainer",
            "--domain-identifier",
            APP_GROUP_ID,
            "--source",
            SNAPSHOT_PATH,
            "--destination",
            str(destination),
        ],
        timeout=60,
    )


def write_and_copy_snapshot(args, payload: dict[str, Any]) -> int:
    with tempfile.TemporaryDirectory(prefix="foil-ios-harness-") as temp_dir:
        temp = Path(temp_dir)
        source = temp / "foil-keyboard-snapshot.json"
        readback = temp / "foil-keyboard-snapshot-readback.json"
        source.write_text(json.dumps(payload, separators=(",", ":")), encoding="utf-8")
        copy_to = copy_snapshot_to_device(source, args.device_id)
        receipt: dict[str, Any] = {
            "schema": "foil.iosPhysicalHarness.appGroupWrite.v1",
            "operation": args.command_name,
            "deviceId": args.device_id,
            "appGroup": APP_GROUP_ID,
            "destination": SNAPSHOT_PATH,
            "copyTo": sanitized_process_result(copy_to),
            "writtenSummary": summarize_snapshot_path(source),
        }
        if copy_to.returncode == 0:
            copy_from = copy_snapshot_from_device(readback, args.device_id)
            receipt["copyFrom"] = sanitized_process_result(copy_from)
            if copy_from.returncode == 0 and readback.exists():
                receipt["readbackSummary"] = summarize_snapshot_path(readback)
        write_json(receipt)
        return 0 if copy_to.returncode == 0 and receipt.get("copyFrom", {}).get("returncode") == 0 else 1


def cmd_stage_transcript(args) -> int:
    transcript = args.transcript_file.read_text(encoding="utf-8") if args.transcript_file else args.transcript
    if transcript is None:
        raise HarnessError("stage-transcript requires --transcript or --transcript-file")
    args.command_name = "stage-transcript"
    return write_and_copy_snapshot(args, snapshot_payload("complete", transcript, args.message))


def cmd_reset_transcript(args) -> int:
    args.command_name = "reset-transcript"
    return write_and_copy_snapshot(args, snapshot_payload("idle", None, args.message))


def cmd_app_group_summary(args) -> int:
    with tempfile.TemporaryDirectory(prefix="foil-ios-harness-") as temp_dir:
        destination = Path(temp_dir) / "foil-keyboard-snapshot.json"
        copy_from = copy_snapshot_from_device(destination, args.device_id)
        receipt: dict[str, Any] = {
            "schema": "foil.iosPhysicalHarness.appGroupSummary.v1",
            "deviceId": args.device_id,
            "appGroup": APP_GROUP_ID,
            "source": SNAPSHOT_PATH,
            "copyFrom": sanitized_process_result(copy_from),
        }
        if copy_from.returncode == 0 and destination.exists():
            receipt["summary"] = summarize_snapshot_path(destination)
        write_json(receipt)
        return 0 if copy_from.returncode == 0 else 1
