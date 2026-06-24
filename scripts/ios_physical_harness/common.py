"""Common process, HTTP, hashing, and receipt helpers."""

from __future__ import annotations

import hashlib
import json
import subprocess
import urllib.request
from typing import Any


class HarnessError(RuntimeError):
    """Expected command-line failure."""


def sha256_text(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def short_hash(value: str) -> str:
    return sha256_text(value)[:16]


def write_json(payload: dict[str, Any]) -> None:
    print(json.dumps(payload, indent=2, sort_keys=True))


def run_command(
    argv: list[str],
    *,
    input_text: str | None = None,
    timeout: int = 30,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        argv,
        input=input_text,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=timeout,
        check=False,
    )


def http_json(
    method: str,
    url: str,
    payload: dict[str, Any] | None = None,
    timeout: int = 5,
) -> dict[str, Any]:
    raw = http_text(method, url, payload=payload, timeout=timeout)
    try:
        decoded = json.loads(raw)
    except json.JSONDecodeError as error:
        raise HarnessError(f"{url} did not return JSON") from error
    if isinstance(decoded, dict):
        return decoded
    raise HarnessError(f"{url} returned non-object JSON")


def http_text(
    method: str,
    url: str,
    payload: dict[str, Any] | None = None,
    timeout: int = 10,
) -> str:
    data = None
    headers = {"Accept": "application/json"}
    if payload is not None:
        data = json.dumps(payload).encode("utf-8")
        headers["Content-Type"] = "application/json"
    request = urllib.request.Request(url, data=data, headers=headers, method=method)
    with urllib.request.urlopen(request, timeout=timeout) as response:
        return response.read().decode("utf-8")


def sanitized_process_result(result: subprocess.CompletedProcess[str]) -> dict[str, Any]:
    return {
        "returncode": result.returncode,
        "stdoutSha256": short_hash(result.stdout) if result.stdout else None,
        "stderrSha256": short_hash(result.stderr) if result.stderr else None,
        "stdoutBytes": len(result.stdout.encode("utf-8")),
        "stderrBytes": len(result.stderr.encode("utf-8")),
    }
