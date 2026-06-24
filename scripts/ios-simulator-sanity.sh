#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="$ROOT_DIR/FoiliOS/FoilIOS.xcodeproj"
SCHEME="FoilIOS"
SIM_DESTINATION="${IOS_SIMULATOR_DESTINATION:-platform=iOS Simulator,name=iPhone 17}"
LIST_TIMEOUT_SECONDS="${IOS_SIMULATOR_SANITY_LIST_TIMEOUT_SECONDS:-120}"
TEST_TIMEOUT_SECONDS="${IOS_SIMULATOR_SANITY_TEST_TIMEOUT_SECONDS:-1200}"
BUILD_TIMEOUT_SECONDS="${IOS_SIMULATOR_SANITY_BUILD_TIMEOUT_SECONDS:-480}"
TEST_ATTEMPTS="${IOS_SIMULATOR_SANITY_TEST_ATTEMPTS:-1}"
RESET_BEFORE_TESTS="${IOS_SIMULATOR_SANITY_RESET_BEFORE_TESTS:-0}"
RESET_TIMEOUT_SECONDS="${IOS_SIMULATOR_SANITY_RESET_TIMEOUT_SECONDS:-120}"
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

simulator_udid_from_destination() {
  local destination="$1"
  if [[ "$destination" =~ (^|,)id=([^,]+) ]]; then
    echo "${BASH_REMATCH[2]}"
  fi
}

reset_selected_simulator() {
  local reason="$1"
  local udid=""
  udid="$(simulator_udid_from_destination "$SIM_DESTINATION")"

  if [[ -z "$udid" ]]; then
    log "phase=simulator-reset status=skip reason=no-destination-id trigger=$reason"
    return 0
  fi

  log "phase=simulator-reset status=start trigger=$reason udid=$udid"
  run_phase "simulator-reset-shutdown" "$RESET_TIMEOUT_SECONDS" xcrun simctl shutdown "$udid" || true
  run_phase "simulator-reset-erase" "$RESET_TIMEOUT_SECONDS" xcrun simctl erase "$udid"
  run_phase "simulator-reset-boot" "$RESET_TIMEOUT_SECONDS" xcrun simctl boot "$udid"
  run_phase "simulator-reset-bootstatus" "$RESET_TIMEOUT_SECONDS" xcrun simctl bootstatus "$udid" -b
  log "phase=simulator-reset status=pass trigger=$reason udid=$udid"
}

run_phase() {
  local phase="$1"
  local timeout_seconds="$2"
  shift 2

  CURRENT_PHASE="$phase"
  log "phase=$phase status=start timeout_seconds=$timeout_seconds command=$(print_command "$@")"

  local status=0
  if python3 - "$phase" "$timeout_seconds" "$@" <<'PY'
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
  then
    status=0
  else
    status=$?
  fi

  if [[ "$status" -eq 0 ]]; then
    log "phase=$phase status=pass"
  else
    log "phase=$phase status=fail exit_code=$status"
  fi

  CURRENT_PHASE="between-phases"
  return "$status"
}

run_phase_with_timeout_retry() {
  local phase="$1"
  local timeout_seconds="$2"
  local attempts="$3"
  shift 3

  local attempt=1
  local status=0

  while true; do
    log "phase=$phase status=attempt-start attempt=$attempt max_attempts=$attempts"

    if run_phase "$phase" "$timeout_seconds" "$@"; then
      status=0
    else
      status=$?
    fi

    if [[ "$status" -eq 0 ]]; then
      return 0
    fi

    if [[ "$status" -ne 124 || "$attempt" -ge "$attempts" ]]; then
      return "$status"
    fi

    log "phase=$phase status=retry reason=timeout exit_code=124 completed_attempt=$attempt next_attempt=$((attempt + 1)) max_attempts=$attempts"
    reset_selected_simulator "retry-after-${phase}-timeout"
    attempt=$((attempt + 1))
  done
}

log "simulator-only regression lane"
log "this does not prove physical keyboard insertion or host-app behavior"
log "destination=$SIM_DESTINATION"
log "timeouts list=${LIST_TIMEOUT_SECONDS}s test=${TEST_TIMEOUT_SECONDS}s build=${BUILD_TIMEOUT_SECONDS}s reset=${RESET_TIMEOUT_SECONDS}s"
log "attempts simulator-tests=${TEST_ATTEMPTS} reset_before_tests=${RESET_BEFORE_TESTS}"

run_phase "project-scheme-visibility" "$LIST_TIMEOUT_SECONDS" \
  xcodebuild -list -project "$PROJECT"

if [[ "$RESET_BEFORE_TESTS" == "1" ]]; then
  reset_selected_simulator "before-simulator-tests"
fi

run_phase_with_timeout_retry "simulator-tests" "$TEST_TIMEOUT_SECONDS" "$TEST_ATTEMPTS" \
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
