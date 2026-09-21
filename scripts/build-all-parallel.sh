#!/bin/sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VERSIONS_URL='https://raw.githubusercontent.com/panascais-docker/node/master/configuration/versions.json'

json_keys() {
  sed -n 's/^[[:space:]]*"\([^"]*\)":[[:space:]]*".*/\1/p' "$1"
}

VERSIONS_FILE=$(mktemp)
cleanup() {
  rm -f "$VERSIONS_FILE"
}
trap cleanup EXIT

curl -fsSL "$VERSIONS_URL" > "$VERSIONS_FILE"

VERSIONS=""
for v in $(json_keys "$VERSIONS_FILE"); do
  if [ -f "$ROOT/$v/Dockerfile" ]; then
    VERSIONS="$VERSIONS $v"
  fi
done

if [ -z "$VERSIONS" ]; then
  echo "no distributions found in upstream metadata" >&2
  exit 1
fi

LOG_DIR="${TMPDIR:-/tmp}ci-node-builds"
mkdir -p "$LOG_DIR"

echo "logs: $LOG_DIR/build-<version>.log"

PIDS=""
for v in $VERSIONS; do
  (
    if bun run build.ts "$v" >"$LOG_DIR/build-$v.log" 2>&1; then
      echo "OK $v"
    else
      echo "FAILURE $v (see $LOG_DIR/build-$v.log)"
      exit 1
    fi
  ) &
  PIDS="$PIDS $!"
done

FAIL=0
for pid in $PIDS; do
  if ! wait "$pid"; then
    FAIL=1
  fi
done

if [ "$FAIL" -ne 0 ]; then
  echo "One or more builds failed."
  exit 1
fi

echo "OK"
