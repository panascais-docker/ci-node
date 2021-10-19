[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/panascais-docker/ci-node/main?style=flat-square)](https://github.com/panascais-docker/ci-node/actions?query=workflow%3Amain)
[![Docker Pulls](https://img.shields.io/docker/pulls/panascais/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)
[![Docker Stars](https://img.shields.io/docker/stars/panascais/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)
[![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)
[![License](https://img.shields.io/github/license/panascais-docker/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)

**CI-Node** is a docker image intended to be used in continuous integration services such as [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/), [GitHub Actions](https://github.com/features/actions), [Semaphore CI](https://semaphoreci.com) and [Circle CI](https://circleci.com)

| **Tag:** | **Command:**                       | **Node Version:** | **Supported:** | **Labels:**                                                                                                   |
| -------- | ---------------------------------- | ----------------- | -------------- | ------------------------------------------------------------------------------------------------------------- |
| `lts`    | `docker pull panascais/ci-node`    | `v14.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/lts.svg?style=flat-square)    |
| `latest` | `docker pull panascais/ci-node`    | `v17.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/latest.svg?style=flat-square) |
| `17`     | `docker pull panascais/ci-node:17` | `v17.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/17.svg?style=flat-square)     |
| `16`     | `docker pull panascais/ci-node:16` | `v16.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/16.svg?style=flat-square)     |
| `15`     | `docker pull panascais/ci-node:15` | `v15.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/15.svg?style=flat-square)     |
| `14`     | `docker pull panascais/ci-node:14` | `v14.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/14.svg?style=flat-square)     |
| `12`     | `docker pull panascais/ci-node:12` | `v12.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/12.svg?style=flat-square)     |
| `10`     | `docker pull panascais/ci-node:10` | `v10.x.x`         | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/10.svg?style=flat-square)     |
| `8`      | `docker pull panascais/ci-node:8`  | `v8.x.x`          | ✓              | ![Docker Image Size](https://img.shields.io/docker/image-size/panascais/ci-node/8.svg?style=flat-square)      |

## Included CLIs

| **Name:**    | **GitHub:**                                                                | **npm:**                                                                 |
| ------------ | -------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `npm`        | [github.com/npm/cli](https://github.com/npm/cli)                           | [npmjs.com/package/npm](https://www.npmjs.com/package/npm)               |
| `pnpm`       | [github.com/pnpm/pnpm](https://github.com/pnpm/pnpm)                       | [npmjs.com/package/pnpm](https://www.npmjs.com/package/pnpm)             |
| `yarn`       | [github.com/yarnpkg/yarn](https://github.com/yarnpkg/yarn)                 | [npmjs.com/package/yarn](https://www.npmjs.com/package/yarn)             |
| `typescript` | [github.com/microsoft/typescript](https://github.com/microsoft/typescript) | [npmjs.com/package/typescript](https://www.npmjs.com/package/typescript) |
| `eslint`     | [github.com/eslint/eslint](https://github.com/eslint/eslint)               | [npmjs.com/package/eslint](https://www.npmjs.com/package/eslint)         |
| `ava`        | [github.com/avajs/ava](https://github.com/avajs/ava)                       | [npmjs.com/package/ava](https://www.npmjs.com/package/ava)               |
| `babel`      | [github.com/babel/babel](https://github.com/babel/babel)                   | [npmjs.com/package/@babel/cli](https://www.npmjs.com/package/@babel/cli) |
| `gulp`       | [github.com/gulpjs/gulp-cli](https://github.com/gulpjs/gulp-cli)           | [npmjs.com/package/gulp-cli](https://www.npmjs.com/package/gulp-cli)     |

## Included Packages

| **Name:**           | **Registry:**                                                                                                             |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `g++`               | [pkgs.alpinelinux.org/package/g++](https://pkgs.alpinelinux.org/package/edge/main/x86_64/g++)                             |
| `gcc`               | [pkgs.alpinelinux.org/package/gcc](https://pkgs.alpinelinux.org/package/edge/main/x86_64/gcc)                             |
| `git`               | [pkgs.alpinelinux.org/package/git](https://pkgs.alpinelinux.org/package/edge/main/x86_64/git)                             |
| `openssl`           | [pkgs.alpinelinux.org/package/openssl](https://pkgs.alpinelinux.org/package/edge/main/x86_64/openssl)                     |
| `gzip`              | [pkgs.alpinelinux.org/package/gzip](https://pkgs.alpinelinux.org/package/edge/main/x86_64/gzip)                           |
| `make`              | [pkgs.alpinelinux.org/package/make](https://pkgs.alpinelinux.org/package/edge/main/x86_64/make)                           |
| `python2`           | [pkgs.alpinelinux.org/package/python2](https://pkgs.alpinelinux.org/package/edge/main/x86_64/python2)                     |
| `python3`           | [pkgs.alpinelinux.org/package/python3](https://pkgs.alpinelinux.org/package/edge/main/x86_64/python3)                     |
| `autoconf`          | [pkgs.alpinelinux.org/package/autoconf](https://pkgs.alpinelinux.org/package/edge/main/x86_64/autoconf)                   |
| `automake`          | [pkgs.alpinelinux.org/package/automake](https://pkgs.alpinelinux.org/package/edge/main/x86_64/automake)                   |
| `curl-dev`          | [pkgs.alpinelinux.org/package/curl-dev](https://pkgs.alpinelinux.org/package/edge/main/x86_64/curl-dev)                   |
| `vips`              | [pkgs.alpinelinux.org/package/vips](https://pkgs.alpinelinux.org/package/edge/testing/x86_64/vips)                        |
| `libjpeg-turbo-dev` | [pkgs.alpinelinux.org/package/libjpeg-turbo-dev](https://pkgs.alpinelinux.org/package/edge/main/x86_64/libjpeg-turbo-dev) |

## Build

**Example for bash and node version 14:**

```sh
docker build \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    -t panascais/ci-node:14 \
    ./14
```

**Example for fish and node version 14:**

```fish
docker build \
    --build-arg BUILD_DATE=(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    --build-arg VCS_REF=(git rev-parse --short HEAD) \
    -t panascais/ci-node:14 \
    ./14
```

## Contributors

- Silas Rech [(silas@panascais.net)](mailto:silas@panascais.net)
- Maximilian Schagginger [(max@panascais.net)](mailto:max@panascais.net)

## Contributing:

Interested in contributing to **CI-Node**? Contributions are welcome, and are accepted via pull requests. Please [review these guidelines](contributing.md) before submitting any pull requests.

## License:

Code licensed under [MIT](license.md), documentation under [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/).
