# `panascais/ci-node`

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/panascais-docker/ci-node/main.yml?branch=master&style=flat-square)](https://github.com/panascais-docker/ci-node/actions?query=workflow%3Amain)
[![Docker Pulls](https://img.shields.io/docker/pulls/panascais/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)
[![Docker Stars](https://img.shields.io/docker/stars/panascais/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)
[![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)
[![License](https://img.shields.io/github/license/panascais-docker/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)

**CI-Node** is a docker image intended to be used in continuous integration services such as [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/), [GitHub Actions](https://github.com/features/actions), [Semaphore CI](https://semaphoreci.com) and [Circle CI](https://circleci.com)

| **Tag:** | **Command:**                        | **Node Version:** | **Supported:** | **Labels:**                                                                                                   |
| -------- | ----------------------------------- | ----------------- | -------------- | ------------------------------------------------------------------------------------------------------------- |
| `lts`    | `docker pull panascais/ci-node:lts` | `v22.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/lts.svg?style=flat-square)    |
| `latest` | `docker pull panascais/ci-node`     | `v24.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/latest.svg?style=flat-square) |
| `24`     | `docker pull panascais/ci-node:24`  | `v24.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/24.svg?style=flat-square)     |
| `23`     | `docker pull panascais/ci-node:23`  | `v23.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/23.svg?style=flat-square)     |
| `22`     | `docker pull panascais/ci-node:22`  | `v22.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/22.svg?style=flat-square)     |
| `21`     | `docker pull panascais/ci-node:21`  | `v21.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/21.svg?style=flat-square)     |
| `20`     | `docker pull panascais/ci-node:20`  | `v20.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/20.svg?style=flat-square)     |
| `19`     | `docker pull panascais/ci-node:19`  | `v19.x.x`         | ×              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/19.svg?style=flat-square)     |
| `18`     | `docker pull panascais/ci-node:18`  | `v18.x.x`         | ×              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/18.svg?style=flat-square)     |
| `17`     | `docker pull panascais/ci-node:17`  | `v17.x.x`         | ×              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/17.svg?style=flat-square)     |
| `16`     | `docker pull panascais/ci-node:16`  | `v16.x.x`         | ×              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/16.svg?style=flat-square)     |
| `15`     | `docker pull panascais/ci-node:15`  | `v15.x.x`         | ×              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/15.svg?style=flat-square)     |
| `14`     | `docker pull panascais/ci-node:14`  | `v14.x.x`         | ×              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/14.svg?style=flat-square)     |
| `12`     | `docker pull panascais/ci-node:12`  | `v12.x.x`         | ×              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/12.svg?style=flat-square)     |
| `10`     | `docker pull panascais/ci-node:10`  | `v10.x.x`         | ×              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/10.svg?style=flat-square)     |
| `8`      | `docker pull panascais/ci-node:8`   | `v8.x.x`          | ×              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/8.svg?style=flat-square)      |

## Included CLIs

| **Name:**    | **GitHub:**                                                                  | **npm:**                                                                         |
| ------------ | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| `fly`        | [github.com/superfly/flyctl](https://github.com/superfly/flyctl)             | ×                                                                                |
| `npm`        | [github.com/npm/cli](https://github.com/npm/cli)                             | [npmjs.com/package/npm](https://www.npmjs.com/package/npm)                       |
| `pnpm`       | [github.com/pnpm/pnpm](https://github.com/pnpm/pnpm)                         | [npmjs.com/package/pnpm](https://www.npmjs.com/package/pnpm)                     |
| `yarn`       | [github.com/yarnpkg/yarn](https://github.com/yarnpkg/yarn)                   | [npmjs.com/package/yarn](https://www.npmjs.com/package/yarn)                     |
| `typescript` | [github.com/microsoft/typescript](https://github.com/microsoft/typescript)   | [npmjs.com/package/typescript](https://www.npmjs.com/package/typescript)         |
| `biome`      | [github.com/biomejs/biome](https://github.com/biomejs/biome)                 | [npmjs.com/package/@biomejs/biome](https://www.npmjs.com/package/@biomejs/biome) |
| `eslint`     | [github.com/eslint/eslint](https://github.com/eslint/eslint)                 | [npmjs.com/package/eslint](https://www.npmjs.com/package/eslint)                 |
| `stylelint`  | [github.com/stylelint/stylelint](https://github.com/stylelint/stylelint)     | [npmjs.com/package/stylelint](https://www.npmjs.com/package/stylelint)           |
| `prettier`   | [github.com/prettier/prettier](https://github.com/prettier/prettier)         | [npmjs.com/package/prettier](https://www.npmjs.com/package/prettier)             |
| `ava`        | [github.com/avajs/ava](https://github.com/avajs/ava)                         | [npmjs.com/package/ava](https://www.npmjs.com/package/ava)                       |
| `babel`      | [github.com/babel/babel](https://github.com/babel/babel)                     | [npmjs.com/package/@babel/cli](https://www.npmjs.com/package/@babel/cli)         |
| `esbuild`    | [github.com/evanw/esbuild](https://github.com/evanw/esbuild)                 | [npmjs.com/package/esbuild](https://www.npmjs.com/package/esbuild)               |
| `swc`        | [github.com/swc-project/swc](https://github.com/swc-project/swc)             | [npmjs.com/package/swc](https://www.npmjs.com/package/swc)                       |
| `rspack`     | [github.com/web-infra-dev/rspack](https://github.com/web-infra-dev/rspack)   | [npmjs.com/package/rspack](https://www.npmjs.com/package/rspack)                 |
| `turbo`      | [github.com/vercel/turbo](https://github.com/vercel/turbo)                   | [npmjs.com/package/turbo](https://www.npmjs.com/package/turbo)                   |
| `vite`       | [github.com/vitejs/vite](https://github.com/vitejs/vite)                     | [npmjs.com/package/vite](https://www.npmjs.com/package/vite)                     |
| `wrangler`   | [github.com/cloudflare/wrangler2](https://github.com/cloudflare/wrangler2)   | [npmjs.com/package/wrangler](https://www.npmjs.com/package/wrangler)             |
| `ts-node`    | [github.com/typestrong/ts-node](https://github.com/typestrong/ts-node)       | [npmjs.com/package/ts-node](https://www.npmjs.com/package/ts-node)               |
| `tsup`       | [github.com/egoist/tsup](https://github.com/egoist/tsup)                     | [npmjs.com/package/tsup](https://www.npmjs.com/package/tsup)                     |
| `zx`         | [github.com/google/zx](https://github.com/google/zx)                         | [npmjs.com/package/zx](https://www.npmjs.com/package/zx)                         |
| `pkg`        | [github.com/yao-pkg/pkg](https://github.com/yao-pkg/pkg)                     | [npmjs.com/package/pkg](https://www.npmjs.com/package/@yao-pkg/pkg)              |
| `rollup`     | [github.com/rollup/rollup](https://github.com/rollup/rollup)                 | [npmjs.com/package/rollup](https://www.npmjs.com/package/rollup)                 |
| `knip`       | [github.com/webpro-nl/knip](https://github.com/webpro-nl/knip)               | [npmjs.com/package/knip](https://www.npmjs.com/package/knip)                     |
| `tsx`        | [github.com/privatenumber/tsx](https://github.com/privatenumber/tsx)         | [npmjs.com/package/tsx](https://www.npmjs.com/package/tsx)                       |

## Included Packages

| **Name:**           | **Registry:**                                                                                                             |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `bash`              | [pkgs.alpinelinux.org/package/bash](https://pkgs.alpinelinux.org/package/edge/main/x86_64/bash)                           |
| `g++`               | [pkgs.alpinelinux.org/package/g++](https://pkgs.alpinelinux.org/package/edge/main/x86_64/g++)                             |
| `gcc`               | [pkgs.alpinelinux.org/package/gcc](https://pkgs.alpinelinux.org/package/edge/main/x86_64/gcc)                             |
| `git`               | [pkgs.alpinelinux.org/package/git](https://pkgs.alpinelinux.org/package/edge/main/x86_64/git)                             |
| `git-lfs`           | [pkgs.alpinelinux.org/package/git-lfs](https://pkgs.alpinelinux.org/package/edge/community/x86_64/git-lfs)                |
| `openssl`           | [pkgs.alpinelinux.org/package/openssl](https://pkgs.alpinelinux.org/package/edge/main/x86_64/openssl)                     |
| `ffmpeg`            | [pkgs.alpinelinux.org/package/ffmpeg](https://pkgs.alpinelinux.org/package/edge/community/x86_64/ffmpeg)                  |
| `gzip`              | [pkgs.alpinelinux.org/package/gzip](https://pkgs.alpinelinux.org/package/edge/main/x86_64/gzip)                           |
| `make`              | [pkgs.alpinelinux.org/package/make](https://pkgs.alpinelinux.org/package/edge/main/x86_64/make)                           |
| `python3`           | [pkgs.alpinelinux.org/package/python3](https://pkgs.alpinelinux.org/package/edge/main/x86_64/python3)                     |
| `jo`                | [pkgs.alpinelinux.org/package/jo](https://pkgs.alpinelinux.org/package/edge/community/x86_64/jo)                          |
| `jq`                | [pkgs.alpinelinux.org/package/jq](https://pkgs.alpinelinux.org/package/edge/main/x86_64/jq)                               |
| `autoconf`          | [pkgs.alpinelinux.org/package/autoconf](https://pkgs.alpinelinux.org/package/edge/main/x86_64/autoconf)                   |
| `automake`          | [pkgs.alpinelinux.org/package/automake](https://pkgs.alpinelinux.org/package/edge/main/x86_64/automake)                   |
| `curl-dev`          | [pkgs.alpinelinux.org/package/curl-dev](https://pkgs.alpinelinux.org/package/edge/main/x86_64/curl-dev)                   |
| `curl`              | [pkgs.alpinelinux.org/package/curl](https://pkgs.alpinelinux.org/package/edge/main/x86_64/curl)                           |
| `vips`              | [pkgs.alpinelinux.org/package/vips](https://pkgs.alpinelinux.org/package/edge/testing/x86_64/vips)                        |
| `libjpeg-turbo-dev` | [pkgs.alpinelinux.org/package/libjpeg-turbo-dev](https://pkgs.alpinelinux.org/package/edge/main/x86_64/libjpeg-turbo-dev) |

## Build

**Example for bash and node version 24:**

```sh
docker build \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    -t panascais/ci-node:24 \
    ./24
```

**Example for fish and node version 24:**

```fish
docker build \
    --build-arg BUILD_DATE=(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    --build-arg VCS_REF=(git rev-parse --short HEAD) \
    -t panascais/ci-node:24 \
    ./24
```

## pnpm and Docker cache mounts

BuildKit cache mounts speed up rebuilds by reusing downloaded packages between builds. Both apk and pnpm use them in this image.

### apk

The large apk install layer mounts `/apk/cache` so `.apk` files are reused across builds. Cache IDs include `${TARGETARCH}` so amd64 and arm64 packages do not mix during multi-platform builds. `sharing=locked` avoids races when matrix jobs build in parallel.

```dockerfile
RUN --mount=type=cache,id=ci-node-apk-${TARGETARCH},sharing=locked,target=/apk/cache \
    apk update --cache-dir /apk/cache \
    && apk add --cache-dir /apk/cache --cache-predownload \
    ...
```

Alpine 3.23 ships **apk-tools 3.x**, where `--update` / `-U` means `--cache-max-age 0` (always refetch). Do not use it with cache mounts. Pass 1 writes into `/apk/cache`; when the apk layer re-runs, `--cache-predownload` reuses cached `.apk` files. The mount never lands in the final image.

### pnpm

**pnpm v11 (Node 22+):** the base `node` image disables the global virtual store (`enableGlobalVirtualStore: false` in `/root/.config/pnpm/config.yaml`) so global installs behave like pnpm v10. A single `pnpm add -g` pass cache-mounts the store at `/root/.local/share/pnpm/store` (`id=ci-node-pnpm-${TARGETARCH},sharing=locked`). Without that setting, mounting the store cache breaks global CLIs at runtime (ae38d12).

**pnpm v10 and below (Node 21 and older):** single-pass global install with the store cache-mounted at pnpm’s default path for that image (no `--store-dir` override). Measure with the same `ENV` as the Dockerfile (`pnpm store path`).

| pnpm | `PNPM_HOME` in ci-node | `pnpm store path` | Cache mount `target=` | Cache id |
|------|------------------------|-------------------|------------------------|----------|
| 6 (Node 12) | `.../pnpm/bin` | `/root/.pnpm-store/v3` | `/root/.pnpm-store` | `ci-node-pnpm-6-${TARGETARCH}` |
| 7–10 (Node 14–21) | `.../pnpm/bin` | `.../pnpm/bin/store/v3` or `.../v10` | `/root/.local/share/pnpm/bin/store` | `ci-node-pnpm-${TARGETARCH}` |
| 11 (Node 22+) | `/root/.local/share/pnpm` | `.../pnpm/store/v10` | `/root/.local/share/pnpm/store` | `ci-node-pnpm-${TARGETARCH}` |

```dockerfile
# Node 12 (pnpm 6)
RUN --mount=type=cache,id=ci-node-pnpm-6-${TARGETARCH},sharing=locked,target=/root/.pnpm-store \
    packages=" ... " \
    && mkdir -p /root/.pnpm-store /root/.local/share/pnpm/bin \
    && pnpm i -g $packages

# Node 14–21 (pnpm 7–10)
RUN --mount=type=cache,id=ci-node-pnpm-${TARGETARCH},sharing=locked,target=/root/.local/share/pnpm/bin/store \
    packages=" ... " \
    buildable=" --allow-build=... " \
    && mkdir -p /root/.local/share/pnpm/bin \
    && pnpm i -g $packages $buildable

# Node 22+ (pnpm 11; inherits enableGlobalVirtualStore: false from base node image)
RUN --mount=type=cache,id=ci-node-pnpm-${TARGETARCH},sharing=locked,target=/root/.local/share/pnpm/store \
    packages=" ... " \
    buildable=" --allow-build=... " \
    && mkdir -p /root/.local/share/pnpm/bin \
    && pnpm add -g $packages $buildable
```

Mount the parent directory (pnpm creates `v3` / `v10` subdirs inside). `${TARGETARCH}` and `sharing=locked` avoid cross-arch mixing and parallel-build store corruption.

When building application images on top of `ci-node`, use a separate project store ([pnpm Docker docs](https://pnpm.io/docker)):

```dockerfile
ENV PNPM_HOME=/pnpm
ENV PATH=${PNPM_HOME}:${PATH}

RUN --mount=type=cache,id=pnpm-${TARGETARCH},sharing=locked,target=/pnpm/store \
    pnpm install --frozen-lockfile
```

`pnpm` itself comes from `/usr/local/bin/pnpm` on the base `node` image.

## Contributors

- Silas Rech [(silas@panascais.net)](mailto:silas@panascais.net)
- Maximilian Schagginger [(max@panascais.net)](mailto:max@panascais.net)

## Contributing

Interested in contributing to **CI-Node**? Contributions are welcome, and are accepted via pull requests. Please [review these guidelines](contributing.md) before submitting any pull requests.

## License

Code licensed under [MIT](license.md), documentation under [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/).
