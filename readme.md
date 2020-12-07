[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/panascais-docker/ci-node/main?style=flat-square)](https://github.com/panascais-docker/ci-node/actions?query=workflow%3Amain)
[![Docker Pulls](https://img.shields.io/docker/pulls/panascais/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)
[![Docker Stars](https://img.shields.io/docker/stars/panascais/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)
[![Docker Image Layers](https://img.shields.io/microbadger/layers/panascais/ci-node.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node)
[![Docker Image Size](https://img.shields.io/microbadger/image-size/panascais/ci-node.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node)
[![License](https://img.shields.io/github/license/panascais-docker/ci-node.svg?style=flat-square)](https://hub.docker.com/r/panascais/ci-node)

**CI-Node** is a docker image intended to be used in continuous integration services such as GitLab and Travis CI

| **Tag:** | **Command:**                       | **Node Version:** | **Labels:**                                                                                                                                                                                                                                                                                                                                 |
|----------|------------------------------------|-------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `latest` | `docker pull panascais/ci-node`    | `v15.x.x`         | [![Docker Image Layers](https://img.shields.io/microbadger/layers/panascais/ci-node/latest.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node) [![Docker Image Size](https://img.shields.io/microbadger/image-size/panascais/ci-node/latest.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node) |
| `15`     | `docker pull panascais/ci-node:15` | `v15.x.x`         | [![Docker Image Layers](https://img.shields.io/microbadger/layers/panascais/ci-node/15.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node) [![Docker Image Size](https://img.shields.io/microbadger/image-size/panascais/ci-node/14.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node)         |
| `14`     | `docker pull panascais/ci-node:14` | `v14.x.x`         | [![Docker Image Layers](https://img.shields.io/microbadger/layers/panascais/ci-node/14.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node) [![Docker Image Size](https://img.shields.io/microbadger/image-size/panascais/ci-node/14.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node)         |
| `12`     | `docker pull panascais/ci-node:12` | `v12.x.x`         | [![Docker Image Layers](https://img.shields.io/microbadger/layers/panascais/ci-node/12.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node) [![Docker Image Size](https://img.shields.io/microbadger/image-size/panascais/ci-node/12.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node)         |
| `10`     | `docker pull panascais/ci-node:10` | `v10.x.x`         | [![Docker Image Layers](https://img.shields.io/microbadger/layers/panascais/ci-node/10.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node) [![Docker Image Size](https://img.shields.io/microbadger/image-size/panascais/ci-node/10.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node)         |
| `8`      | `docker pull panascais/ci-node:8`  | `v8.x.x`          | [![Docker Image Layers](https://img.shields.io/microbadger/layers/panascais/ci-node/8.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node) [![Docker Image Size](https://img.shields.io/microbadger/image-size/panascais/ci-node/8.svg?style=flat-square)](https://microbadger.com/images/panascais/ci-node)           |

## Included CLIs

| **Name:**    | **GitHub:**                                                                | **npm:**                                                                 |
|--------------|----------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `npm`        | [github.com/npm/cli](https://github.com/npm/cli)                           | [npmjs.com/package/npm](https://www.npmjs.com/package/npm)               |
| `pnpm`       | [github.com/pnpm/pnpm](https://github.com/pnpm/pnpm)                       | [npmjs.com/package/pnpm](https://www.npmjs.com/package/pnpm)             |
| `yarn`       | [github.com/yarnpkg/yarn](https://github.com/yarnpkg/yarn)                 | [npmjs.com/package/yarn](https://www.npmjs.com/package/yarn)             |
| `typescript` | [github.com/microsoft/typescript](https://github.com/Microsoft/TypeScript) | [npmjs.com/package/typescript](https://www.npmjs.com/package/typescript) |
| `eslint`     | [github.com/eslint/eslint](https://github.com/eslint/eslint)               | [npmjs.com/package/eslint](https://www.npmjs.com/package/eslint)         |
| `ava`        | [github.com/avajs/ava](https://github.com/avajs/ava)                       | [npmjs.com/package/ava](https://www.npmjs.com/package/ava)               |
| `babel`      | [github.com/babel/babel](https://github.com/babel/babel)                   | [npmjs.com/package/@babel/cli](https://www.npmjs.com/package/@babel/cli) |
| `gulp`       | [github.com/gulpjs/gulp-cli](https://github.com/gulpjs/gulp-cli)           | [npmjs.com/package/gulp-cli](https://www.npmjs.com/package/gulp-cli)     |

## Included Packages

| **Name:**  | **Registry:**                                                                                                                      |
|------------|------------------------------------------------------------------------------------------------------------------------------------|
| `g++`               | [pkgs.alpinelinux.org/package/g++](https://pkgs.alpinelinux.org/package/edge/main/x86_64/g++)                             |
| `gcc`               | [pkgs.alpinelinux.org/package/gcc](https://pkgs.alpinelinux.org/package/edge/main/x86_64/gcc)                             |
| `git`               | [pkgs.alpinelinux.org/package/git](https://pkgs.alpinelinux.org/package/edge/main/x86_64/git)                             |
| `gzip`              | [pkgs.alpinelinux.org/package/gzip](https://pkgs.alpinelinux.org/package/edge/main/x86_64/gzip)                           |
| `make`              | [pkgs.alpinelinux.org/package/make](https://pkgs.alpinelinux.org/package/edge/main/x86_64/make)                           |
| `python2`           | [pkgs.alpinelinux.org/package/python2](https://pkgs.alpinelinux.org/package/edge/main/x86_64/python2)                     |
| `autoconf`          | [pkgs.alpinelinux.org/package/autoconf](https://pkgs.alpinelinux.org/package/edge/main/x86_64/autoconf)                   |
| `automake`          | [pkgs.alpinelinux.org/package/automake](https://pkgs.alpinelinux.org/package/edge/main/x86_64/automake)                   |
| `curl-dev`          | [pkgs.alpinelinux.org/package/curl-dev](https://pkgs.alpinelinux.org/package/edge/main/x86_64/curl-dev)                   |
| `vips`              | [pkgs.alpinelinux.org/package/vips](https://pkgs.alpinelinux.org/package/edge/testing/x86_64/vips)                        |
| `libjpeg-turbo-dev` | [pkgs.alpinelinux.org/package/libjpeg-turbo-dev](https://pkgs.alpinelinux.org/package/edge/main/x86_64/libjpeg-turbo-dev) |

## Contributors

 - Silas Rech [(silas@panascais.net)](mailto:silas@panascais.net)

## Contributing:

Interested in contributing to **CI-Node**? Contributions are welcome, and are accepted via pull requests. Please [review these guidelines](contributing.md) before submitting any pull requests.

## License:
Code licensed under [MIT](license.md), documentation under [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/).
