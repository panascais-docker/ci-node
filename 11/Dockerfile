FROM node:11-alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-url="https://github.com/panascais-docker/ci-node.git" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="Node CI Image" \
      org.label-schema.description="Panascais Node Continuous Integration Image" \
      org.label-schema.vendor="Panascais Lda. / ehf." \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Panascais Open Source <oss@panascais.net>"

RUN apk add --update \
    g++ \
    gcc \
    autoconf \
    automake \
    git \
    gzip \
    make \
    python2 \
    libjpeg-turbo-dev \
    && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing vips \
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
