#!/usr/bin/env python3
"""Check tracked text files for trailing whitespace.

`git diff --check` is useful locally, but a clean GitHub Actions checkout has
no diff. This scanner checks committed tracked text content directly so hosted
CI can fail when a PR introduces trailing spaces or tabs.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import tempfile
from pathlib import Path


EXCLUDED_PREFIXES = (
    ".git/",
)


def tracked_files() -> list[str]:
    output = subprocess.check_output(["git", "ls-files"], text=True)
    return [line for line in output.splitlines() if line]


def is_binary(data: bytes) -> bool:
    return b"\0" in data


def line_body(line: bytes) -> bytes:
    if line.endswith(b"\r\n"):
        return line[:-2]
    if line.endswith((b"\n", b"\r")):
        return line[:-1]
    return line


def trailing_whitespace_locations(path: Path) -> list[int]:
    data = path.read_bytes()
    if is_binary(data):
        return []

    locations: list[int] = []
    for number, line in enumerate(data.splitlines(keepends=True), 1):
        if line_body(line).endswith((b" ", b"\t")):
            locations.append(number)
    return locations


def scan_files(root: Path, files: list[str]) -> list[tuple[str, int]]:
    violations: list[tuple[str, int]] = []
    for relative in files:
        if relative.startswith(EXCLUDED_PREFIXES):
            continue
        path = root / relative
        if not path.is_file():
            continue
        for line_number in trailing_whitespace_locations(path):
            violations.append((relative, line_number))
    return violations


def self_test() -> int:
    checks = []

    def record(
        name: str, passed: bool, locations: list[tuple[str, int]] | None = None
    ) -> None:
        checks.append(
            {
                "name": name,
                "passed": passed,
                "locations": [
                    {"path": path, "line": line} for path, line in (locations or [])
                ],
            }
        )

    with tempfile.TemporaryDirectory(prefix="foil-whitespace-self-test-") as temp_dir:
        root = Path(temp_dir)
        (root / "clean.txt").write_text("alpha\nbeta\n", encoding="utf-8")
        (root / "trailing-space.txt").write_text("alpha \nbeta\n", encoding="utf-8")
        (root / "trailing-tab.txt").write_text("alpha\nbeta\t\n", encoding="utf-8")
        (root / "crlf.txt").write_bytes(b"alpha\r\nbeta \r\n")
        (root / "binary.bin").write_bytes(b"alpha \0 beta \n")

        clean = scan_files(root, ["clean.txt", "binary.bin"])
        record("clean-text-and-binary-pass", clean == [], clean)

        trailing = scan_files(
            root, ["trailing-space.txt", "trailing-tab.txt", "crlf.txt"]
        )
        record(
            "trailing-space-tab-and-crlf-fail",
            trailing
            == [
                ("trailing-space.txt", 1),
                ("trailing-tab.txt", 2),
                ("crlf.txt", 2),
            ],
            trailing,
        )

    passed = all(check["passed"] for check in checks)
    print(
        json.dumps(
            {
                "schema": "foil.sourceWhitespaceCheck.selfTest.v1",
                "passed": passed,
                "checks": checks,
            },
            indent=2,
            sort_keys=True,
        )
    )
    return 0 if passed else 1


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Fail when tracked text files contain trailing whitespace."
    )
    parser.add_argument(
        "--self-test",
        action="store_true",
        help="Run fixture-only fail-closed checks for trailing whitespace detection.",
    )
    parser.add_argument(
        "--max-report",
        type=int,
        default=50,
        help="Maximum number of file:line violations to print. Default: 50.",
    )
    args = parser.parse_args()

    if args.self_test:
        return self_test()

    root = Path.cwd()
    violations = scan_files(root, tracked_files())

    if violations:
        print("Trailing whitespace violations:")
        for relative, line_number in violations[: args.max_report]:
            print(f"  {relative}:{line_number}")
        remaining = len(violations) - args.max_report
        if remaining > 0:
            print(f"  ... {remaining} more")
        return 1

    print("Trailing whitespace violations: none")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
