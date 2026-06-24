"""Argument parser and entry point for the physical-device harness."""

from __future__ import annotations

import argparse
import subprocess
import sys
import urllib.error
from pathlib import Path

from .app_group import cmd_app_group_summary, cmd_reset_transcript, cmd_stage_transcript
from .common import HarnessError
from .constants import DEVICE_ID, DEVICE_NAME, WDA_URL
from .device_wda import cmd_delete_session, cmd_fetch_source, cmd_preflight, cmd_session, cmd_status, cmd_wda_command
from .receipt import cmd_receipt, cmd_self_test


def add_common_device_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--device-id", default=DEVICE_ID, help=f"CoreDevice id for {DEVICE_NAME}.")


def add_common_wda_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--wda-url", default=WDA_URL, help="Base WebDriverAgent URL.")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Foil iOS physical-device harness.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    status = subparsers.add_parser("status", help="Print sanitized device and WDA readiness.")
    add_common_device_args(status)
    add_common_wda_args(status)
    status.set_defaults(func=cmd_status)

    preflight = subparsers.add_parser("preflight", help="Classify physical automation health before private surfaces.")
    add_common_device_args(preflight)
    add_common_wda_args(preflight)
    preflight.add_argument("--strict", action="store_true", help="Exit non-zero unless classification is healthy.")
    preflight.set_defaults(func=cmd_preflight)

    wda_command = subparsers.add_parser("wda-command", help="Print the foreground WDA xcodebuild command.")
    wda_command.set_defaults(func=cmd_wda_command)

    session = subparsers.add_parser("session", help="Create a current-app WDA session without bundleId.")
    add_common_wda_args(session)
    session.set_defaults(func=cmd_session)

    delete_session = subparsers.add_parser("delete-session", help="Delete a WDA session id.")
    add_common_wda_args(delete_session)
    delete_session.add_argument("session_id")
    delete_session.set_defaults(func=cmd_delete_session)

    fetch_source = subparsers.add_parser("fetch-source", help="Fetch WDA source to a file without printing it.")
    add_common_wda_args(fetch_source)
    fetch_source.add_argument("session_id")
    fetch_source.add_argument("--output", required=True, type=Path)
    fetch_source.set_defaults(func=cmd_fetch_source)

    stage = subparsers.add_parser("stage-transcript", help="Stage a sterile transcript in the Foil App Group.")
    add_common_device_args(stage)
    stage.add_argument("--transcript", help="Sterile transcript text. It is hashed in output, not printed.")
    stage.add_argument("--transcript-file", type=Path, help="File containing sterile transcript text.")
    stage.add_argument("--message", default="Fake transcript ready")
    stage.set_defaults(func=cmd_stage_transcript)

    reset = subparsers.add_parser("reset-transcript", help="Reset Foil App Group transcript state to idle.")
    add_common_device_args(reset)
    reset.add_argument("--message", default="Ready")
    reset.set_defaults(func=cmd_reset_transcript)

    summary = subparsers.add_parser("app-group-summary", help="Copy and summarize the Foil App Group snapshot.")
    add_common_device_args(summary)
    summary.set_defaults(func=cmd_app_group_summary)

    receipt = subparsers.add_parser("receipt", help="Create sanitized WDA evidence via ios-physical-wda-evidence.py.")
    receipt.add_argument("--source", required=True, type=Path)
    receipt.add_argument("--target", required=True)
    receipt.add_argument("--require-identifier", action="append", default=[])
    receipt.add_argument("--forbid-identifier", action="append", default=[])
    receipt.add_argument("--expect-identifier-state", action="append", default=[])
    receipt.add_argument("--require-value", action="append", default=[])
    receipt.add_argument("--forbid-value", action="append", default=[])
    receipt.add_argument("--require-text", action="append", default=[])
    receipt.add_argument("--forbid-text", action="append", default=[])
    receipt.add_argument("--expect-value-count", action="append", default=[])
    receipt.add_argument("--app-group-snapshot", type=Path)
    receipt.add_argument("--storage-report", type=Path)
    receipt.add_argument("--write-json", type=Path)
    receipt.set_defaults(func=cmd_receipt)

    self_test = subparsers.add_parser("self-test", help="Run fixture-only privacy and fail-closed checks.")
    self_test.set_defaults(func=cmd_self_test)

    return parser


def main(argv: list[str]) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        return args.func(args)
    except HarnessError as error:
        print(f"error: {error}", file=sys.stderr)
        return 2
    except urllib.error.URLError as error:
        print(f"error: WDA request failed: {error}", file=sys.stderr)
        return 2
    except subprocess.TimeoutExpired as error:
        print(f"error: command timed out: {error.cmd}", file=sys.stderr)
        return 2
