#!/bin/sh
# Probe global package install + --version smoke for one ci-node distribution.
# Usage: ./scripts/probe-version.sh 12
set -eu

VER="${1:?usage: probe-version.sh <12|14|...|26|latest|lts>}"
OUT="/tmp/ci-node-probe-${VER}.txt"

case "$VER" in
  12) NODE_TAG=12.22.12; PNPM=6; SETUP=legacy12 ;;
  14) NODE_TAG=14.21.3; PNPM=7; SETUP=legacy14 ;;
  15) NODE_TAG=15.14.0; PNPM=7; SETUP=legacy15 ;;
  16) NODE_TAG=16.20.2; PNPM=8; SETUP=legacy16 ;;
  17) NODE_TAG=17.9.1; PNPM=8; SETUP=legacy17 ;;
  18) NODE_TAG=18.20.8; PNPM=10; SETUP=extended18 ;;
  19) NODE_TAG=19.9.0; PNPM=10; SETUP=extended19 ;;
  20) NODE_TAG=20.20.2; PNPM=10; SETUP=extended20 ;;
  21) NODE_TAG=21.7.3; PNPM=10; SETUP=extended21 ;;
  22) NODE_TAG=22.22.3; PNPM=11; SETUP=modern ;;
  23) NODE_TAG=23.11.1; PNPM=11; SETUP=modern ;;
  24) NODE_TAG=24.15.0; PNPM=11; SETUP=modern ;;
  25) NODE_TAG=25.9.0; PNPM=11; SETUP=modern ;;
  26) NODE_TAG=26.1.0; PNPM=11; SETUP=modern ;;
  latest) NODE_TAG=24.15.0; PNPM=11; SETUP=modern ;;
  lts) NODE_TAG=22.22.3; PNPM=11; SETUP=modern ;;
  *) echo "unknown: $VER" >&2; exit 2 ;;
esac

IMAGE="node:${NODE_TAG}-alpine"
: > "$OUT"
echo "=== probe ${VER} node:${NODE_TAG} pnpm:${PNPM} setup:${SETUP} ===" | tee "$OUT"

docker run --rm -i -e SETUP="$SETUP" -e PNPM_VER="$PNPM" "$IMAGE" sh -s <<'SCRIPT' 2>&1 | tee -a "$OUT"
set -eu
apk add --no-cache curl >/dev/null
curl -fsSL https://get.pnpm.io/v6.js | node - add --global "pnpm@${PNPM_VER}"
export NPM_CONFIG_PACKAGE_IMPORT_METHOD=copy

MODERN_PKGS='@babel/cli @babel/core @biomejs/biome @rspack/cli @swc/cli @swc/core @types/node @yao-pkg/pkg ava esbuild eslint@10 knip prettier rollup stylelint ts-node tsup tsx turbo typescript vite wrangler yarn zx'
MODERN_INSTALL='pnpm add -g --allow-build=@swc/core --allow-build=esbuild --allow-build=oxc-resolver --allow-build=sharp --allow-build=workerd --allow-build=yarn'
LEGACY_EXT_INSTALL='pnpm i -g'

case "$SETUP" in
  legacy12)
    export PATH="/usr/local/bin:$PATH"
    PKGS='@babel/cli @babel/core @types/node ava@3 esbuild@0.17 eslint@8 pnpm@'"${PNPM_VER}"' prettier@2 rollup@2 stylelint@14 ts-node@10 tsx@3 typescript@4 vite@2 yarn'
    INSTALL="pnpm i -g"
    ;;
  legacy14)
    export PNPM_HOME=/root/.local/share/pnpm/bin PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PKGS='@babel/cli @babel/core @biomejs/biome@1 @rspack/cli@0.5.9 @rspack/core@0.5.9 @types/node @yao-pkg/pkg@5 ava@4 esbuild@0.17 eslint@8 pnpm@'"${PNPM_VER}"' prettier@3 rollup@2 stylelint@14 ts-node@10 tsx@3 turbo@1 typescript@4 vite@3 yarn zx@5'
    INSTALL="$LEGACY_EXT_INSTALL"
    ;;
  legacy15)
    export PNPM_HOME=/root/.local/share/pnpm/bin PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PKGS='@babel/cli @babel/core @biomejs/biome@1 @types/node @yao-pkg/pkg@5 ava@4 esbuild@0.17 eslint@8 pnpm@'"${PNPM_VER}"' prettier@3 rollup@2 stylelint@14 ts-node@10 tsx@3 turbo@1 typescript@4 vite@3 yarn zx@5'
    INSTALL="$LEGACY_EXT_INSTALL"
    ;;
  legacy16)
    export PNPM_HOME=/root/.local/share/pnpm/bin PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PKGS='@babel/cli @babel/core @biomejs/biome@1 @rspack/cli@0.7.5 @rspack/core@0.7.5 @types/node @yao-pkg/pkg@5 ava@5 esbuild@0.19 eslint@8 pnpm@'"${PNPM_VER}"' prettier@3 rollup@3 stylelint@15 ts-node@10 tsx@3 turbo@1 typescript@5 vite@3 yarn zx@6'
    INSTALL="$LEGACY_EXT_INSTALL"
    ;;
  legacy17)
    export PNPM_HOME=/root/.local/share/pnpm/bin PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PKGS='@babel/cli @babel/core @biomejs/biome@1 @rspack/cli@0.7.5 @rspack/core@0.7.5 @types/node @yao-pkg/pkg@5 ava@5 esbuild@0.19 eslint@8 pnpm@'"${PNPM_VER}"' prettier@3 rollup@3 stylelint@15 ts-node@10 tsx@3 turbo@1 typescript@5 vite@3 wrangler@3 yarn zx@7'
    INSTALL="$LEGACY_EXT_INSTALL"
    ;;
  extended18)
    export PNPM_HOME=/root/.local/share/pnpm/bin PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PKGS='@babel/cli @babel/core @biomejs/biome@1 @rspack/cli @swc/cli @swc/core @types/node @yao-pkg/pkg@5 ava@5 esbuild eslint@10 knip@5 pnpm@'"${PNPM_VER}"' prettier rollup stylelint@16 ts-node tsup tsx turbo typescript vite@6 wrangler@3 yarn zx@7'
    INSTALL="pnpm i -g --allow-build=@biomejs/biome --allow-build=@swc/core --allow-build=esbuild --allow-build=oxc-resolver --allow-build=sharp --allow-build=workerd --allow-build=yarn"
    ;;
  extended19)
    export PNPM_HOME=/root/.local/share/pnpm/bin PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PKGS='@babel/cli @babel/core @biomejs/biome@1 @rspack/cli @swc/cli @swc/core @types/node @yao-pkg/pkg@5 ava@6 esbuild eslint@10 knip@5 pnpm@'"${PNPM_VER}"' prettier rollup stylelint@16 ts-node tsup tsx turbo typescript vite@6 wrangler@3 yarn zx@7'
    INSTALL="pnpm i -g --allow-build=@biomejs/biome --allow-build=@swc/core --allow-build=esbuild --allow-build=oxc-resolver --allow-build=sharp --allow-build=workerd --allow-build=yarn"
    ;;
  extended20)
    export PNPM_HOME=/root/.local/share/pnpm/bin PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PKGS='@babel/cli @babel/core @biomejs/biome@1 @rspack/cli @swc/cli @swc/core @types/node @yao-pkg/pkg ava@6 esbuild eslint@10 knip pnpm@'"${PNPM_VER}"' prettier rollup stylelint ts-node tsup tsx turbo typescript vite wrangler@3 yarn zx@8'
    INSTALL="pnpm i -g --allow-build=@biomejs/biome --allow-build=@swc/core --allow-build=esbuild --allow-build=oxc-resolver --allow-build=sharp --allow-build=workerd --allow-build=yarn"
    ;;
  extended21)
    export PNPM_HOME=/root/.local/share/pnpm/bin PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PKGS='@babel/cli @babel/core @biomejs/biome@1 @swc/cli @swc/core @types/node @yao-pkg/pkg@5 ava@6 esbuild eslint@10 knip@5 pnpm@'"${PNPM_VER}"' prettier rollup stylelint@16 ts-node tsup tsx turbo typescript vite@6 wrangler@3 yarn zx@8'
    INSTALL="pnpm i -g --allow-build=@biomejs/biome --allow-build=@swc/core --allow-build=esbuild --allow-build=oxc-resolver --allow-build=sharp --allow-build=workerd --allow-build=yarn"
    ;;
  modern)
    export PNPM_HOME=/root/.local/share/pnpm PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"
    mkdir -p /root/.local/share/pnpm/bin
    PKGS="$MODERN_PKGS"
    INSTALL="$MODERN_INSTALL"
    ;;
esac

echo "--- INSTALL ---"
if ! sh -c "$INSTALL $PKGS" 2>&1 | tail -12; then
  echo "INSTALL_FAILED"
  exit 1
fi

echo "--- SMOKE ---"
FAIL=0
smoke() {
  name="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    out=$("$@" 2>&1 | head -1)
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

PROBE_EXIT=${PIPESTATUS[0]:-$?}
echo "=== exit: $PROBE_EXIT ===" | tee -a "$OUT"
exit $PROBE_EXIT
