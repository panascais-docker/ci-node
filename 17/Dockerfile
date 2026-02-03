FROM alpine:3.23 AS flyctl

ARG ARCHITECTURE=x86_64
ARG VERSION=0.4.0

RUN if [ "$TARGETARCH" = "arm64" ]; then ARCHITECTURE=arm64; fi \
    && wget -qO- "https://github.com/superfly/flyctl/releases/download/v${VERSION}/flyctl_${VERSION}_Linux_${ARCHITECTURE}.tar.gz" \
    | tar -xz -C / flyctl

FROM ghcr.io/panascais-docker/node/node:17.9.1

COPY --from=flyctl /flyctl /usr/local/bin/flyctl
RUN ln -s /usr/local/bin/flyctl /usr/local/bin/fly

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

RUN apk add --no-cache --update \
    autoconf \
    automake \
    bash \
    build-base \
    ca-certificates \
    cairo-dev \
    curl \
    curl-dev \
    deno \
    ffmpeg \
    g++ \
    gcc \
    gcompat \
    giflib-dev \
    git \
    git-lfs \
    gzip \
    icu \
    icu-libs \
    jo \
    jq \
    libc6-compat \
    libgcc \
    libjpeg-turbo-dev \
    libstdc++ \
    linux-headers \
    make \
    musl \
    musl-dev \
    musl-utils \
    openssl \
    pango-dev \
    py-setuptools \
    python3 \
    simdutf \
    vips \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/*

RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/bin/store \
    mkdir -p /root/.local/share/pnpm/bin \
    && pnpm i -g \
    @babel/cli \
    @babel/core \
    @types/node \
    @yao-pkg/pkg \
    ava \
    eslint \
    pnpm@8 \
    prettier \
    rollup \
    stylelint \
    ts-node \
    tsx \
    turbo \
    typescript \
    vite@3 \
    yarn \
    zx

RUN export BUN_INSTALL=/usr/local \
    && curl -fsSL https://bun.com/install | bash -s "bun-v1.2.22"

# smoke tests
RUN bun --version \
    && deno --version \
    && node --version \
    && fly version
