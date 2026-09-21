#!/bin/sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VERSIONS_URL='https://raw.githubusercontent.com/panascais-docker/node/master/configuration/versions.json'
PNPM_URL='https://raw.githubusercontent.com/panascais-docker/node/master/configuration/pnpm.json'

json_keys() {
  sed -n 's/^[[:space:]]*"\([^"]*\)":[[:space:]]*".*/\1/p' "$1"
}

CI_NODE_VERSIONS_FILE=$(mktemp)
CI_NODE_PNPM_FILE=$(mktemp)
cleanup() {
  rm -f "$CI_NODE_VERSIONS_FILE" "$CI_NODE_PNPM_FILE"
}
trap cleanup EXIT

curl -fsSL "$VERSIONS_URL" > "$CI_NODE_VERSIONS_FILE"
curl -fsSL "$PNPM_URL" > "$CI_NODE_PNPM_FILE"

export CI_NODE_VERSIONS_FILE
export CI_NODE_PNPM_FILE

VERSIONS=""
for v in $(json_keys "$CI_NODE_VERSIONS_FILE"); do
  if [ -f "$ROOT/$v/Dockerfile" ]; then
    VERSIONS="$VERSIONS $v"
  fi
done

if [ -z "$VERSIONS" ]; then
  echo "no distributions found in upstream metadata" >&2
  exit 1
fi

PIDS=""
for v in $VERSIONS; do
  (
    if ./scripts/probe-version.sh "$v"; then
      echo "PROBE OK $v"
    else
      echo "PROBE FAIL $v"
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
  echo "One or more probes failed. See /tmp/ci-node-probe-*.txt"
  exit 1
fi

echo "All probes OK"
