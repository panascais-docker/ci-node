FROM panascais/node:8

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-url="https://github.com/panascais-docker/ci-node.git" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="Node CI Image" \
    org.label-schema.description="Panascais Node Continuous Integration Image" \
    org.label-schema.vendor="Panascais Inc." \
    org.label-schema.schema-version="1.0.0-rc1" \
    maintainer="Panascais Open Source <oss@panascais.net>"

RUN node -v && \
    apk add --update \
    g++ \
    gcc \
    autoconf \
    automake \
    curl-dev \
    git \
    gzip \
    make \
    python2 \
    python3 \
    libjpeg-turbo-dev \
    vips \
    && rm -rf /var/cache/apk/* \
    && pnpm i -g \
    typescript \
    eslint \
    ava \
    gulp-cli \
    @babel/core @babel/cli \
    yarn
