FROM alpine:3.24 AS flyctl

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


FROM alpine:3.24 AS deno

ARG BUILD_DATE
ARG TARGETARCH
ARG DENO_VERSION=latest

# deno only ships glibc builds, so it gets an isolated glibc that does not clash with musl or gcompat
COPY --from=gcr.io/distroless/cc-debian12 /lib/*-linux-gnu/ /usr/local/lib/glibc/

RUN set -eu \
  && echo "deno:${BUILD_DATE}" \
  && apk add --no-cache patchelf \
  && download_architecture=x86_64 \
  && interpreter=ld-linux-x86-64.so.2 \
  && if [ "${TARGETARCH}" = "arm64" ]; then download_architecture=aarch64; interpreter=ld-linux-aarch64.so.1; fi \
  && download_version="${DENO_VERSION}" \
  && if [ "$download_version" = "latest" ]; then download_version=$(wget -qO- https://dl.deno.land/release-latest.txt); fi \
  && download_file="deno-${download_architecture}-unknown-linux-gnu.zip" \
  && download_url="https://dl.deno.land/release/v${download_version#v}/${download_file}" \
  && wget -qO "/${download_file}" "$download_url" \
  && wget -qO "/${download_file}.sha256sum" "${download_url}.sha256sum" \
  && cd / \
  && sha256sum -c "${download_file}.sha256sum" \
  && unzip -q "$download_file" deno \
  && patchelf --set-interpreter "/usr/local/lib/glibc/${interpreter}" --set-rpath /usr/local/lib/glibc /deno \
  && /deno --version


FROM ghcr.io/panascais-docker/node/node:19.9.0 AS image

COPY --from=flyctl /flyctl /usr/local/bin/flyctl
RUN ln -s /usr/local/bin/flyctl /usr/local/bin/fly

COPY --from=deno /usr/local/lib/glibc /usr/local/lib/glibc
COPY --from=deno /deno /usr/local/bin/deno

ARG BUILD_DATE
ARG NODE_VERSION
ARG PNPM_VERSION
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
  ffmpeg \
  g++ \
  gcc \
  gcompat \
  giflib-dev \
  git \
  git-lfs \
  gzip \
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

RUN --mount=type=cache,id=ci-node-pnpm-${PNPM_VERSION}-${TARGETARCH},sharing=locked,target=/root/.local/share/pnpm/store \
  packages=" \
  @babel/cli@7 \
  @babel/core@7 \
  @biomejs/biome@1 \
  @rspack/cli \
  @swc/cli \
  @swc/core \
  @types/node \
  @yao-pkg/pkg@5 \
  ava@6 \
  esbuild \
  eslint@10 \
  knip@5 \
  prettier \
  rollup \
  stylelint@16 \
  ts-node \
  tsup@8 \
  tsx \
  turbo \
  typescript@6 \
  vite@6 \
  wrangler@3 \
  yarn \
  zx@7 \
  " \
  buildable=" \
  --allow-build=@biomejs/biome \
  --allow-build=@swc/core \
  --allow-build=oxc-resolver \
  --allow-build=sharp \
  --allow-build=yarn \
  " \
  && mkdir -p /root/.local/share/pnpm/bin \
  && pnpm config set global-bin-dir /root/.local/share/pnpm/bin \
  && pnpm add -g $packages $buildable \
  && rm -rf /root/.cache/pnpm

RUN export BUN_INSTALL=/usr/local \
  && curl -fsSL https://bun.com/install | bash

RUN curl -fsSL https://nubjs.com/install.sh | bash

FROM image AS smoke

RUN ava --version \
  && babel --version \
  && biome --version \
  && bun --version \
  && deno --version \
  && deno eval 'console.log(await (await fetch("https://dl.deno.land/release-latest.txt")).text())' \
  && [ "$(deno eval 'console.log(new Intl.DateTimeFormat("de", { month: "long" }).format(new Date(0)))')" = "Januar" ] \
  && esbuild --version \
  && eslint --version \
  && fly --version \
  && knip --version \
  && node --version \
  && [ "$(node -p 'new Intl.DateTimeFormat("de", { month: "long" }).format(new Date(0))')" = "Januar" ] \
  && pkg --version \
  && pnpm --version \
  && prettier --version \
  && rollup --version \
  && stylelint --version \
  && swc --version \
  && tsc --version \
  && tsup --version \
  && tsx --version \
  && turbo --version \
  && vite --version \
  && wrangler --version \
  && zx --version


FROM image
