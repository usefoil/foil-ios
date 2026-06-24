#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="$ROOT_DIR/FoiliOS/FoilIOS.xcodeproj"
SCHEME="FoilIOS"
SIM_DESTINATION="${IOS_SIMULATOR_DESTINATION:-platform=iOS Simulator,name=iPhone 17}"
LIST_TIMEOUT_SECONDS="${IOS_SIMULATOR_SANITY_LIST_TIMEOUT_SECONDS:-120}"
TEST_TIMEOUT_SECONDS="${IOS_SIMULATOR_SANITY_TEST_TIMEOUT_SECONDS:-1200}"
BUILD_TIMEOUT_SECONDS="${IOS_SIMULATOR_SANITY_BUILD_TIMEOUT_SECONDS:-480}"
CURRENT_PHASE="startup"

timestamp() {
  date -u "+%Y-%m-%dT%H:%M:%SZ"
}

log() {
  echo "foil-ios-simulator-sanity: ts=$(timestamp) $*"
}

print_command() {
  local rendered=""
  printf -v rendered "%q " "$@"
  echo "${rendered% }"
}

on_signal() {
  local signal="$1"
  log "signal=$signal phase=$CURRENT_PHASE"
}

trap 'on_signal TERM' TERM
trap 'on_signal INT' INT

run_phase() {
  local phase="$1"
  local timeout_seconds="$2"
  shift 2

  CURRENT_PHASE="$phase"
  log "phase=$phase status=start timeout_seconds=$timeout_seconds command=$(print_command "$@")"

  set +e
  python3 - "$phase" "$timeout_seconds" "$@" <<'PY'
import os
import signal
import subprocess
import sys
import time

phase = sys.argv[1]
timeout_seconds = int(sys.argv[2])
command = sys.argv[3:]
started = time.monotonic()

process = subprocess.Popen(command, start_new_session=True)

try:
    return_code = process.wait(timeout=timeout_seconds)
except subprocess.TimeoutExpired:
    elapsed = int(time.monotonic() - started)
    print(
        "foil-ios-simulator-sanity: "
        f"phase={phase} status=timeout elapsed_seconds={elapsed} "
        f"timeout_seconds={timeout_seconds}",
        flush=True,
    )
    try:
        os.killpg(process.pid, signal.SIGTERM)
        process.wait(timeout=10)
    except Exception:
        try:
            os.killpg(process.pid, signal.SIGKILL)
        except Exception:
            pass
    sys.exit(124)

sys.exit(return_code)
PY
  local status=$?
  set -e

  if [[ "$status" -eq 0 ]]; then
    log "phase=$phase status=pass"
  else
    log "phase=$phase status=fail exit_code=$status"
  fi

  CURRENT_PHASE="between-phases"
  return "$status"
}

log "simulator-only regression lane"
log "this does not prove physical keyboard insertion or host-app behavior"
log "destination=$SIM_DESTINATION"
log "timeouts list=${LIST_TIMEOUT_SECONDS}s test=${TEST_TIMEOUT_SECONDS}s build=${BUILD_TIMEOUT_SECONDS}s"

run_phase "project-scheme-visibility" "$LIST_TIMEOUT_SECONDS" \
  xcodebuild -list -project "$PROJECT"

run_phase "simulator-tests" "$TEST_TIMEOUT_SECONDS" \
  xcodebuild test \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "$SIM_DESTINATION"

run_phase "unsigned-generic-ios-build" "$BUILD_TIMEOUT_SECONDS" \
  xcodebuild build \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO

log "passed"
