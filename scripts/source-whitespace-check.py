#!/usr/bin/env python3
"""Check tracked text files for trailing whitespace.

`git diff --check` is useful locally, but a clean GitHub Actions checkout has
no diff. This scanner checks committed tracked text content directly so hosted
CI can fail when a PR introduces trailing spaces or tabs.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
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


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Fail when tracked text files contain trailing whitespace."
    )
    parser.add_argument(
        "--max-report",
        type=int,
        default=50,
        help="Maximum number of file:line violations to print. Default: 50.",
    )
    args = parser.parse_args()

    root = Path.cwd()
    violations: list[tuple[str, int]] = []

    for relative in tracked_files():
        if relative.startswith(EXCLUDED_PREFIXES):
            continue
        path = root / relative
        if not path.is_file():
            continue
        for line_number in trailing_whitespace_locations(path):
            violations.append((relative, line_number))

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
