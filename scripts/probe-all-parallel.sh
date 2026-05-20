#!/bin/sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VERSIONS="12 14 15 16 17 18 19 20 21 22 23 24 25 26 latest lts"
FAIL=0

for v in $VERSIONS; do
  (
    if ./scripts/probe-version.sh "$v"; then
      echo "PROBE OK $v"
    else
      echo "PROBE FAIL $v"
      exit 1
    fi
  ) &
done

for v in $VERSIONS; do
  if ! wait; then
    FAIL=1
  fi
done

if [ "$FAIL" -ne 0 ]; then
  echo "One or more probes failed. See /tmp/ci-node-probe-*.txt"
  exit 1
fi

echo "All probes OK"
