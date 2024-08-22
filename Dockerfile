# Use the alpine:3.20 as the base image
FROM alpine:3.20

# Install necessary packages for building Node.js
RUN apk add --no-cache \
    curl \
    python3 \
    make \
    g++ \
    && ARCH=$(uname -m) \
    && case "$ARCH" in \
    x86_64) NODE_ARCH="x64";; \
    aarch64) NODE_ARCH="arm64";; \
    armv7l) NODE_ARCH="armv7l";; \
    ppc64le) NODE_ARCH="ppc64le";; \
    s390x) NODE_ARCH="s390x";; \
    *) echo "Unsupported architecture: $ARCH"; exit 1;; \
    esac \
    && NODE_VERSION="v22.7.0" \
    && curl -fsSL "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz" -o /tmp/node.tar.gz \
    && tar -xzf /tmp/node.tar.gz -C /tmp \
    && cd /tmp/node-${NODE_VERSION} \
    && ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install \
    && cd / \
    && rm -rf /tmp/node-${NODE_VERSION} /tmp/node.tar.gz \
    && apk del curl python3 make g++

# Set node to be the default command
ENTRYPOINT ["node"]

# Show node version to verify installation
CMD ["--version"]
