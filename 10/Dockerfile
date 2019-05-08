FROM node:10-alpine
LABEL vcs-url="https://github.com/panascais-docker/ci-node"
LABEL vendor="Panascais Lda. / ehf."
LABEL maintainer="Panascais Open Source <oss@panascais.net>"

RUN apk add --update \
    g++ \
    gcc \
    git \
    gzip \
    make \
    python \
    && rm -rf /var/cache/apk/* \
    && yarn global add \
    typescript \
    tslint \
    eslint \
    ava \
    gulp \
    && yarn cache clean
