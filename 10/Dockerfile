FROM node:10-alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-url="https://github.com/panascais-docker/ci-node.git"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.name="Node CI Image"
LABEL org.label-schema.description="Panascais Node Continuous Integration Image"
LABEL org.label-schema.vendor="Panascais Lda. / ehf."
LABEL org.label-schema.schema-version="1.0.0-rc1"
LABEL maintainer="Panascais Open Source <oss@panascais.net>"

RUN apk add --update \
    g++ \
    gcc \
    git \
    gzip \
    make \
    python2 \
    && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing vips
    && rm -rf /var/cache/apk/* \
    && yarn global add \
    typescript \
    tslint \
    eslint \
    ava \
    gulp-cli \
    @babel/core @babel/cli \
    pnpm \
    && yarn cache clean
