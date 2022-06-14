FROM panascais/node:lts

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-url="https://github.com/panascais-docker/ci-node.git" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="Node CI Image" \
    org.label-schema.description="Panascais Node Continuous Integration Image" \
    org.label-schema.vendor="Panascais ehf." \
    org.label-schema.schema-version="1.0.0" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.version=$VERSION \
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

RUN node -v && \
    apk add --update \
    g++ \
    gcc \
    autoconf \
    automake \
    bash \
    curl-dev \
    curl \
    git \
    git-lfs \
    gzip \
    make \
    python3 \
    jo \
    jq \
    libjpeg-turbo-dev \
    vips \
    openssl \
    && rm -rf /var/cache/apk/* \
    && pnpm i -g \
    typescript \
    eslint \
    prettier \
    ava \
    gulp-cli \
    @babel/core @babel/cli \
    yarn \
    depcheck \
    zx \
    && export FLYCTL_INSTALL=/usr/local \
    && curl -L https://fly.io/install.sh | sh
