import { $ } from 'bun';

// constants

const pnpmFile = 'https://raw.githubusercontent.com/panascais-docker/node/master/configuration/pnpm.json';
const versionsFile = 'https://raw.githubusercontent.com/panascais-docker/node/master/configuration/versions.json';
const [, , distribution] = Bun.argv;

// utilities

const fetchJson = async <T>(url: string) => {
    const response = await fetch(url);
    if (!response.ok) {
        throw new Error(`Failed to fetch ${url}: ${response.statusText}`);
    }

    const json = await response.json();
    return json as T;
};

const getPnpmVersion = async () => {
    const json = await fetchJson<Record<string, string>>(pnpmFile);

    const version = json[distribution] as string;
    if (typeof version !== 'string' || !version?.length) {
        throw new Error(`Invalid pnpm version found: '${version}' in '${JSON.stringify(json)}\n'`);
    }

    return version;
};

const getImageTag = async () => {
    const json = await fetchJson<Record<string, string>>(versionsFile);

    const tag = json[distribution] as string;
    if (typeof tag !== 'string' || !tag?.length) {
        throw new Error(`Invalid node tag found: '${tag}' in '${JSON.stringify(json)}\n'`);
    }

    return tag;
};

// business logic

const [imageTag, pnpmVersion] = await Promise.all([getImageTag(), getPnpmVersion()]);

const [major, min, pat] = imageTag.split('.');
const minor = `${major}.${min}`;
const patch = `${minor}.${pat}`;

// the same BUILD_DATE must be passed to every build of one run, otherwise the RUN layers never hit the cache
const buildDate = (await $`date -u +"%Y-%m-%dT%H:%M:%SZ"`.text()).trim();
const vcsRef = (await $`git rev-parse --short HEAD`.text()).trim();

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
    // the smoke stage is a side target so its test run never becomes a layer of the published image
    await $`docker buildx build \
        --build-arg BUILD_DATE=${buildDate} \
        --build-arg NODE_VERSION=${patch} \
        --build-arg PNPM_VERSION=${pnpmVersion} \
        --build-arg VCS_REF=${vcsRef} \
        --platform linux/amd64,linux/arm64 \
        --progress=plain \
        --target smoke \
        ./${distribution}`;

    await $`echo ${CONTAINER_REGISTRY_TOKEN} | docker login ghcr.io -u ${CONTAINER_REGISTRY_USERNAME} --password-stdin`;
    await $`echo ${DOCKER_REGISTRY_TOKEN} | docker login -u ${DOCKER_REGISTRY_USERNAME} --password-stdin`;
    await $`echo ${QUAY_REGISTRY_TOKEN} | docker login quay.io -u ${QUAY_REGISTRY_USERNAME} --password-stdin`;

    await $`docker buildx build \
        --build-arg BUILD_DATE=${buildDate} \
        --build-arg NODE_VERSION=${patch} \
        --build-arg PNPM_VERSION=${pnpmVersion} \
        --build-arg VCS_REF=${vcsRef} \
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
    await $`docker buildx create --name orb --use &> /dev/null || docker buildx use orb`;
    await $`docker buildx inspect --bootstrap &> /dev/null`;
    await $`docker buildx install &> /dev/null || true`;

    await $`docker buildx build \
        --build-arg BUILD_DATE=${buildDate} \
        --build-arg NODE_VERSION=${patch} \
        --build-arg PNPM_VERSION=${pnpmVersion} \
        --build-arg VCS_REF=${vcsRef} \
        --platform linux/arm64 \
        --progress=plain \
        --target smoke \
        ./${distribution}`;

    await $`docker buildx build \
        --build-arg BUILD_DATE=${buildDate} \
        --build-arg NODE_VERSION=${patch} \
        --build-arg PNPM_VERSION=${pnpmVersion} \
        --build-arg VCS_REF=${vcsRef} \
        --load \
        --platform linux/arm64 \
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
