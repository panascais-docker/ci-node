FROM alpine:3.23 AS flyctl

ARG BUILD_DATE
ARG TARGETARCH
ARG FLYCTL_VERSION=latest

RUN set -eu \
  && echo "flyctl:${BUILD_DATE}" \
  && download_architecture=x86_64 \
  && if [ "${TARGETARCH}" = "arm64" ]; then download_architecture=arm64; fi \
  && download_version="${FLYCTL_VERSION}" \
  && if [ "$download_version" = "latest" ]; then \
    location=$(wget -qSO- "https://github.com/superfly/flyctl/releases/latest/download/flyctl_Linux_$(echo "$download_architecture").tar.gz" 2>&1 \
      | awk '/^[[:space:]]*Location:/{gsub(/\r/,""); print $2; exit}'); \
    download_version=$(echo "$location" | sed -n 's|.*/download/v\([^/]*\)/.*|\1|p'); \
  fi \
  && wget -qO- "https://github.com/superfly/flyctl/releases/download/v$(echo "$download_version")/flyctl_$(echo "$download_version")_Linux_$(echo "$download_architecture").tar.gz" \
  | tar -xz -C / flyctl


FROM ghcr.io/panascais-docker/node/node:16.20.2

COPY --from=flyctl /flyctl /usr/local/bin/flyctl
RUN ln -s /usr/local/bin/flyctl /usr/local/bin/fly

ARG BUILD_DATE
ARG NODE_VERSION
ARG TARGETARCH
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
    PATH="/usr/local/bin:/root/.local/share/pnpm/bin:$PATH"

RUN --mount=type=cache,id=ci-node-apk-${TARGETARCH},sharing=locked,target=/apk/cache \
    apk update --cache-dir /apk/cache \
    && apk add --cache-dir /apk/cache --cache-predownload \
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
    && update-ca-certificates

RUN --mount=type=cache,id=ci-node-pnpm-16-${TARGETARCH},sharing=locked,target=/root/.local/share/pnpm/bin/store \
    packages=" \
    @babel/cli \
    @babel/core \
    @biomejs/biome@1 \
    @rspack/cli@0.7.5 \
    @rspack/core@0.7.5 \
    @types/node \
    @yao-pkg/pkg@5 \
    ava@5 \
    esbuild@0.19 \
    eslint@8 \
    pnpm@8 \
    prettier@3 \
    rollup@3 \
    stylelint@15 \
    ts-node@10 \
    tsx@3 \
    turbo@1 \
    typescript@5 \
    vite@3 \
    yarn \
    zx@6 \
    " \
    && mkdir -p /root/.local/share/pnpm/bin \
    && pnpm i -g $packages

RUN export BUN_INSTALL=/usr/local \
    && curl -fsSL https://bun.com/install | bash -s "bun-v1.3.14"

# smoke tests
RUN ava --version \
    && babel --version \
    && biome --version \
    && bun --version \
    && deno --version \
    && esbuild --version \
    && eslint --version \
    && fly --version \
    && node --version \
    && pkg --version \
    && pnpm --version \
    && prettier --version \
    && rollup --version \
    && rspack --version \
    && stylelint --version \
    && tsc --version \
    && tsx --version \
    && turbo --version \
    && vite --version \
    && zx --version
