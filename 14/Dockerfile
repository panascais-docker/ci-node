FROM ghcr.io/panascais-docker/node/node:14.21.3

ARG BUILD_DATE
ARG NODE_VERSION
ARG VCS_REF

LABEL org.label-schema.vcs-url="https://github.com/panascais-docker/ci-node.git" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="Node CI Image" \
    org.label-schema.description="Panascais Node Continuous Integration Image" \
    org.label-schema.vendor="Panascais ehf." \
    org.label-schema.schema-version="1.0.0" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.title="Node CI Image" \
    org.opencontainers.image.description="Panascais Node Continuous Integration Image" \
    org.opencontainers.image.url=https://nodejs.org \
    org.opencontainers.image.documentation="https://github.com/panascais-docker/ci-node" \
    org.opencontainers.image.vendor="Panascais ehf." \
    org.opencontainers.image.licenses=MIT \
    org.opencontainers.image.source="https://github.com/panascais-docker/ci-node" \
    maintainer="Panascais Open Source <oss@panascais.net>"

ENV PNPM_HOME="/root/.local/share/pnpm/bin" \
    PATH="/root/.local/share/pnpm/bin:$PATH"

RUN mkdir -p /root/.local/share/pnpm/bin \
    && node -v && \
    apk add --update \
    autoconf \
    automake \
    bash \
    curl \
    curl-dev \
    g++ \
    gcc \
    git \
    git-lfs \
    gzip \
    jo \
    jq \
    libjpeg-turbo-dev \
    make \
    openssl \
    python3 \
    vips \
    && rm -rf /var/cache/apk/* \
    && pnpm i -g \
    @babel/cli \
    @babel/core \
    @types/node \
    @yao-pkg/pkg \
    ava \
    depcheck \
    eslint \
    gulp-cli \
    parcel \
    pnpm@7 \
    prettier \
    rollup \
    stylelint \
    tap-junit \
    ts-node \
    turbo \
    typescript \
    yarn \
    zx \
    && export FLYCTL_INSTALL=/usr/local \
    && for i in {1..5}; do curl -L https://fly.io/install.sh | sh && break || sleep 5; done \
    # smoke tests
    && fly version
