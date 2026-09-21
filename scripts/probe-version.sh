#!/bin/sh
# Probe global package install + --version smoke for one ci-node distribution.
# Usage: ./scripts/probe-version.sh 12
set -eu

DISTRIBUTION="${1:?usage: probe-version.sh <distribution>}"
case "$DISTRIBUTION" in
  latest|lts) ;;
  ''|*[!0-9]*)
    echo "invalid distribution: ${DISTRIBUTION}" >&2
    exit 1
    ;;
esac
OUTPUT="/tmp/ci-node-probe-${DISTRIBUTION}.txt"

VERSIONS_URL='https://raw.githubusercontent.com/panascais-docker/node/master/configuration/versions.json'
PNPM_URL='https://raw.githubusercontent.com/panascais-docker/node/master/configuration/pnpm.json'

json_string() {
  _file=$1
  _key=$2
  _val=$(sed -n 's/^[[:space:]]*"'"${_key}"'":[[:space:]]*"\([^"]*\)".*/\1/p' "$_file" | sed -n '1p')
  if [ -z "$_val" ]; then
    echo "missing key '${_key}' in ${_file}" >&2
    return 1
  fi
  printf '%s\n' "$_val"
}

OWN_VERSIONS=0
OWN_PNPM=0
DOCKER_LOG=""
cleanup() {
  if [ "$OWN_VERSIONS" -eq 1 ]; then
    rm -f "$CI_NODE_VERSIONS_FILE"
  fi
  if [ "$OWN_PNPM" -eq 1 ]; then
    rm -f "$CI_NODE_PNPM_FILE"
  fi
  if [ -n "$DOCKER_LOG" ]; then
    rm -f "$DOCKER_LOG"
  fi
}
trap cleanup EXIT

if [ -z "${CI_NODE_VERSIONS_FILE:-}" ] || [ ! -f "${CI_NODE_VERSIONS_FILE}" ]; then
  CI_NODE_VERSIONS_FILE=$(mktemp)
  OWN_VERSIONS=1
  curl -fsSL "$VERSIONS_URL" > "$CI_NODE_VERSIONS_FILE"
fi
if [ -z "${CI_NODE_PNPM_FILE:-}" ] || [ ! -f "${CI_NODE_PNPM_FILE}" ]; then
  CI_NODE_PNPM_FILE=$(mktemp)
  OWN_PNPM=1
  curl -fsSL "$PNPM_URL" > "$CI_NODE_PNPM_FILE"
fi

NODE_TAG=$(json_string "$CI_NODE_VERSIONS_FILE" "$DISTRIBUTION")
PNPM=$(json_string "$CI_NODE_PNPM_FILE" "$DISTRIBUTION")
NODE_MAJOR=${NODE_TAG%%.*}

case "$NODE_MAJOR" in
  12) SETUP=legacy12 ;;
  14) SETUP=legacy14 ;;
  15) SETUP=legacy15 ;;
  16) SETUP=legacy16 ;;
  17) SETUP=legacy17 ;;
  18) SETUP=extended18 ;;
  19) SETUP=extended19 ;;
  20) SETUP=extended20 ;;
  21) SETUP=extended21 ;;
  22|23|24|25|26) SETUP=modern ;;
  *)
    echo "unsupported node major: ${NODE_MAJOR} (tag ${NODE_TAG})" >&2
    exit 2
    ;;
esac

case "$PNPM" in
  6|7|8|12) ;;
  *)
    echo "unsupported pnpm major: ${PNPM}" >&2
    exit 2
    ;;
esac

IMAGE="node:${NODE_TAG}-alpine"
: > "$OUTPUT"
echo "=== probe ${DISTRIBUTION} node:${NODE_TAG} pnpm:${PNPM} setup:${SETUP} ===" | tee "$OUTPUT"

DOCKER_LOG=$(mktemp)
PROBE_EXIT=0
docker run --rm -i -e SETUP="$SETUP" -e PNPM_VERSION="$PNPM" "$IMAGE" sh -s <<'SCRIPT' >"$DOCKER_LOG" 2>&1 || PROBE_EXIT=$?
set -eu
apk add --no-cache curl >/dev/null
curl -fsSL https://get.pnpm.io/v6.js | node - add --global "pnpm@${PNPM_VERSION}"
export NPM_CONFIG_PACKAGE_IMPORT_METHOD=copy

MODERN_PKGS='@babel/cli @babel/core @biomejs/biome @rspack/cli @swc/cli @swc/core @types/node @yao-pkg/pkg ava esbuild eslint@10 knip prettier rollup stylelint ts-node tsup tsx turbo typescript@6 vite wrangler yarn zx'
MODERN_BUILDABLE='--allow-build=@swc/core --allow-build=esbuild --allow-build=oxc-resolver --allow-build=sharp --allow-build=workerd --allow-build=yarn'
EXTENDED_BUILDABLE='--allow-build=@biomejs/biome --allow-build=@swc/core --allow-build=esbuild --allow-build=oxc-resolver --allow-build=sharp --allow-build=workerd --allow-build=yarn'

case "$SETUP" in
  legacy12)
    PKGS='@babel/cli@7 @babel/core@7 @types/node ava@3 esbuild@0.17 eslint@8 prettier@2 rollup@2 stylelint@14 ts-node@10 tsx@3 typescript@4 vite@2 yarn'
    BUILDABLE=""
    ;;
  legacy14)
    PKGS='@babel/cli@7 @babel/core@7 @biomejs/biome@1 @rspack/cli@0.5.9 @rspack/core@0.5.9 @types/node @yao-pkg/pkg@5 ava@4 esbuild@0.17 eslint@8 prettier@3 rollup@2 stylelint@14 ts-node@10 tsx@3 turbo@1 typescript@4 vite@3 yarn zx@5'
    BUILDABLE=""
    ;;
  legacy15)
    PKGS='@babel/cli@7 @babel/core@7 @biomejs/biome@1 @types/node @yao-pkg/pkg@5 ava@4 esbuild@0.17 eslint@8 prettier@3 rollup@2 stylelint@14 ts-node@10 tsx@3 turbo@1 typescript@4 vite@3 yarn zx@5'
    BUILDABLE=""
    ;;
  legacy16)
    PKGS='@babel/cli@7 @babel/core@7 @biomejs/biome@1 @rspack/cli@0.7.5 @rspack/core@0.7.5 @types/node @yao-pkg/pkg@5 ava@5 esbuild@0.19 eslint@8 prettier@3 rollup@3 stylelint@15 ts-node@10 tsx@3 turbo@1 typescript@5 vite@3 yarn zx@6'
    BUILDABLE=""
    ;;
  legacy17)
    PKGS='@babel/cli@7 @babel/core@7 @biomejs/biome@1 @rspack/cli@0.7.5 @rspack/core@0.7.5 @types/node @yao-pkg/pkg@5 ava@5 esbuild@0.19 eslint@8 prettier@3 rollup@3 stylelint@15 ts-node@10 tsx@3 turbo@1 typescript@5 vite@3 wrangler@3 yarn zx@7'
    BUILDABLE=""
    ;;
  extended18)
    PKGS='@babel/cli@7 @babel/core@7 @biomejs/biome@1 @rspack/cli @swc/cli @swc/core @types/node @yao-pkg/pkg@5 ava@5 esbuild eslint@10 knip@5 prettier rollup stylelint@16 ts-node tsup tsx turbo typescript@6 vite@6 wrangler@3 yarn zx@7'
    BUILDABLE="$EXTENDED_BUILDABLE"
    ;;
  extended19)
    PKGS='@babel/cli@7 @babel/core@7 @biomejs/biome@1 @rspack/cli @swc/cli @swc/core @types/node @yao-pkg/pkg@5 ava@6 esbuild eslint@10 knip@5 prettier rollup stylelint@16 ts-node tsup tsx turbo typescript@6 vite@6 wrangler@3 yarn zx@7'
    BUILDABLE="$EXTENDED_BUILDABLE"
    ;;
  extended20)
    PKGS='@babel/cli @babel/core @biomejs/biome@1 @rspack/cli @swc/cli @swc/core @types/node @yao-pkg/pkg ava@6 esbuild eslint@10 knip prettier rollup stylelint ts-node tsup tsx turbo typescript@6 vite wrangler@3 yarn zx@8'
    BUILDABLE="$EXTENDED_BUILDABLE"
    ;;
  extended21)
    PKGS='@babel/cli @babel/core @biomejs/biome@1 @swc/cli @swc/core @types/node @yao-pkg/pkg@5 ava@6 esbuild eslint@10 knip@5 prettier rollup stylelint@16 ts-node tsup tsx turbo typescript@6 vite@6 wrangler@3 yarn zx@8'
    BUILDABLE="$EXTENDED_BUILDABLE"
    ;;
  modern)
    PKGS="$MODERN_PKGS"
    BUILDABLE="$MODERN_BUILDABLE"
    ;;
  *)
    echo "unknown setup: $SETUP" >&2
    exit 2
    ;;
esac

case "$PNPM_VERSION" in
  6)
    export PATH="/usr/local/bin:$PATH"
    PNPM_CMD="pnpm i -g"
    ;;
  7|8)
    export PNPM_HOME=/root/.local/share/pnpm/bin
    export PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PNPM_CMD="pnpm i -g"
    ;;
  12)
    export PNPM_HOME=/root/.local/share/pnpm
    export PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PNPM_CMD="pnpm add -g"
    ;;
  *)
    echo "unsupported pnpm major: ${PNPM_VERSION}" >&2
    exit 2
    ;;
esac

echo "--- INSTALL ---"
install_log=/tmp/ci-node-install.log
set +e
sh -c "$PNPM_CMD $PKGS $BUILDABLE" >"$install_log" 2>&1
install_exit=$?
set -e
tail -12 "$install_log"
if [ "$install_exit" -ne 0 ]; then
  echo "INSTALL_FAILED"
  exit 1
fi

echo "--- SMOKE ---"
FAIL=0
smoke() {
  name="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    out=$("$@" 2>&1 | sed -n '1p')
    echo "OK  $name  $out"
  else
    echo "FAIL $name"
    FAIL=1
  fi
}

smoke ava ava --version
smoke babel babel --version

case "$SETUP" in
  legacy14|legacy15|legacy16|legacy17|extended*|modern)
    smoke biome biome --version
    ;;
esac

case "$SETUP" in
  legacy12|legacy14|legacy15|legacy16|legacy17|extended*|modern)
    smoke esbuild esbuild --version
    ;;
esac

smoke eslint eslint --version
smoke pnpm pnpm --version

case "$SETUP" in
  extended*|modern)
    smoke knip knip --version
    ;;
esac

case "$SETUP" in
  legacy14|legacy15|legacy16|legacy17|extended18|extended19|extended20|extended21|modern)
    smoke pkg pkg --version
    ;;
esac

smoke prettier prettier --version
smoke rollup rollup --version

case "$SETUP" in
  legacy14|legacy16|legacy17|extended20|modern)
    smoke rspack rspack --version
    ;;
esac

smoke stylelint stylelint --version

case "$SETUP" in
  extended*|modern)
    smoke swc swc --version
    ;;
esac

smoke tsc tsc --version

case "$SETUP" in
  extended*|modern)
    smoke tsup tsup --version
    ;;
esac

smoke tsx tsx --version

case "$SETUP" in
  legacy14|legacy15|legacy16|legacy17|extended*|modern)
    smoke turbo turbo --version
    ;;
esac

smoke vite vite --version

case "$SETUP" in
  legacy17|extended*|modern)
    smoke wrangler wrangler --version
    ;;
esac

case "$SETUP" in
  legacy14|legacy15|legacy16|legacy17|extended*|modern)
    smoke zx zx --version
    ;;
esac

exit $FAIL
SCRIPT

tee -a "$OUTPUT" < "$DOCKER_LOG"
echo "=== exit: $PROBE_EXIT ===" | tee -a "$OUTPUT"
exit "$PROBE_EXIT"
