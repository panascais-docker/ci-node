#!/bin/sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VERSIONS_URL='https://raw.githubusercontent.com/panascais-docker/node/master/configuration/versions.json'

json_keys() {
  sed -n 's/^[[:space:]]*"\([^"]*\)":[[:space:]]*".*/\1/p' "$1"
}

is_allowed_distribution() {
  case "$1" in
    latest|lts) return 0 ;;
    ''|*[!0-9]*) return 1 ;;
    *) return 0 ;;
  esac
}

VERSIONS_FILE=$(mktemp)
KEYS_FILE=$(mktemp)
cleanup() {
  rm -f "$VERSIONS_FILE" "$KEYS_FILE"
}
trap cleanup EXIT

curl -fsSL "$VERSIONS_URL" > "$VERSIONS_FILE"
json_keys "$VERSIONS_FILE" > "$KEYS_FILE"

VERSIONS=""
while IFS= read -r v || [ -n "$v" ]; do
  [ -z "$v" ] && continue
  if ! is_allowed_distribution "$v"; then
    echo "ignoring malformed distribution key: ${v}" >&2
    continue
  fi
  if [ -f "${ROOT}/${v}/Dockerfile" ]; then
    VERSIONS="${VERSIONS} ${v}"
  fi
done < "$KEYS_FILE"

if [ -z "$VERSIONS" ]; then
  echo "no valid repository distributions remain" >&2
  exit 1
fi

LOG_DIR="${TMPDIR:-/tmp}/ci-node-builds"
mkdir -p "$LOG_DIR"

echo "logs: ${LOG_DIR}/build-<version>.log"

PIDS=""
for v in $VERSIONS; do
  (
    if bun run build.ts "$v" >"${LOG_DIR}/build-${v}.log" 2>&1; then
      echo "OK ${v}"
    else
      echo "FAILURE ${v} (see ${LOG_DIR}/build-${v}.log)"
      exit 1
    fi
  ) &
  PIDS="${PIDS} $!"
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
