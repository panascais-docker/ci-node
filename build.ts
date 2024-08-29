import { $ } from 'bun'

// constants

const pnpmFile = './configuration/pnpm.json';
const tagsFile = './configuration/tags.json';
const [, , distribution] = Bun.argv;

// utilities

const fetchJson = async <T>(url: string) => {
    const response = await fetch(url);
    if (!response.ok) {
        throw new Error(`Failed to fetch ${url}: ${response.statusText}`);
    }

    const json = await response.json();
    return json as T
};

const getPnpmVersion = async () => {
    const json = await fetchJson<Record<string, string>>('https://raw.githubusercontent.com/panascais-docker/node/master/configuration/pnpm.json')

    const version = json[distribution] as string;
    if (typeof version !== 'string' || !version?.length) {
        throw new Error(`Invalid pnpm version found: '${version}' in '${JSON.stringify(json)}\n'`);
    }

    return version;
}

const getImageTag = async () => {
    const json = await fetchJson<Record<string, string>>('https://raw.githubusercontent.com/panascais-docker/node/master/configuration/versions.json')

    const tag = json[distribution] as string;
    if (typeof tag !== 'string' || !tag?.length) {
        throw new Error(`Invalid node tag found: '${tag}' in '${JSON.stringify(json)}\n'`);
    }

    return tag;
}

const getDockerfilePath = () => {
    return `./${distribution}/Dockerfile`
}

const getDockerfile = async () => {
    const dockerfile = await Bun.file(getDockerfilePath()).text();
    return dockerfile;
}

const setDockerfile = async (dockerfile: string) => {
    return Bun.write(getDockerfilePath(), dockerfile);
}

// business logic

const [pnpm, tag, dockerfile] = await Promise.all([getPnpmVersion(), getImageTag(), getDockerfile()]);
const lines = new Array<string>()

if (true as boolean) {
    // process.exit(0)
}

for (const line of dockerfile.split('\n')) {
    if (line.startsWith("FROM")) {
        lines.push(`FROM ghcr.io/panascais-docker/node/ci-node:${tag}`)
        continue;
    }
    if (line.startsWith('    pnpm')) {
        lines.push(`    pnpm@${pnpm} \\`);
        continue;
    }
    lines.push(line);
}

await setDockerfile(lines.join('\n'));

const [major, min, pat] = tag.split('.')
const minor = `${major}.${min}`
const patch = `${minor}.${pat}`

if (Bun.env.GITHUB_ACTIONS === 'true') {
    const {
        CONTAINER_REGISTRY_TOKEN,
        CONTAINER_REGISTRY_USERNAME,
        DOCKER_REGISTRY_TOKEN,
        DOCKER_REGISTRY_USERNAME,
        QUAY_REGISTRY_TOKEN,
        QUAY_REGISTRY_USERNAME,
    } = Bun.env;

    // hack to pull first without authentication to avoid even more rate limits
    await $`docker buildx create --use && docker buildx build \
        --build-arg BUILD_DATE=${await $`date -u +"%Y-%m-%dT%H:%M:%SZ"`.text()} \
        --build-arg NODE_VERSION=${patch} \
        --build-arg VCS_REF=${await $`git rev-parse --short HEAD`.text()} \
        --platform linux/amd64,linux/arm64 \
        --progress=plain \
        ./${distribution}`;

    await $`echo ${CONTAINER_REGISTRY_TOKEN} | docker login ghcr.io -u ${CONTAINER_REGISTRY_USERNAME} --password-stdin`;
    await $`echo ${DOCKER_REGISTRY_TOKEN} | docker login -u ${DOCKER_REGISTRY_USERNAME} --password-stdin`;
    await $`echo ${QUAY_REGISTRY_TOKEN} | docker login quay.io -u ${QUAY_REGISTRY_USERNAME} --password-stdin`;

    await $`docker buildx build \
        --build-arg BUILD_DATE=${await $`date -u +"%Y-%m-%dT%H:%M:%SZ"`.text()} \
        --build-arg NODE_VERSION=${patch} \
        --build-arg VCS_REF=${await $`git rev-parse --short HEAD`.text()} \
        --push \
        --platform linux/amd64,linux/arm64 \
        --progress=plain \
        -t ghcr.io/panascais-docker/node/ci-node:${distribution} \
        -t ghcr.io/panascais-docker/node/ci-node:${major} \
        -t ghcr.io/panascais-docker/node/ci-node:${minor} \
        -t ghcr.io/panascais-docker/node/ci-node:${patch} \
        -t panascais/ci-node:${distribution} \
        -t panascais/ci-node:${major} \
        -t panascais/ci-node:${minor} \
        -t panascais/ci-node:${patch} \
        -t quay.io/panascais/ci-node:${distribution} \
        -t quay.io/panascais/ci-node:${major} \
        -t quay.io/panascais/ci-node:${minor} \
        -t quay.io/panascais/ci-node:${patch} \
        ./${distribution}`;
} else {
    await $`docker buildx build \
        --build-arg BUILD_DATE=${await $`date -u +"%Y-%m-%dT%H:%M:%SZ"`.text()} \
        --build-arg NODE_VERSION=${patch} \
        --build-arg VCS_REF=${await $`git rev-parse --short HEAD`.text()} \
        --load \
        --progress=plain \
        -t ghcr.io/panascais-docker/node/ci-node:${distribution} \
        -t ghcr.io/panascais-docker/node/ci-node:${major} \
        -t ghcr.io/panascais-docker/node/ci-node:${minor} \
        -t ghcr.io/panascais-docker/node/ci-node:${patch} \
        -t panascais/ci-node:${distribution} \
        -t panascais/ci-node:${major} \
        -t panascais/ci-node:${minor} \
        -t panascais/ci-node:${patch} \
        -t quay.io/panascais/ci-node:${distribution} \
        -t quay.io/panascais/ci-node:${major} \
        -t quay.io/panascais/ci-node:${minor} \
        -t quay.io/panascais/ci-node:${patch} \
        ./${distribution}`;
}
