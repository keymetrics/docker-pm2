# GitHub Actions Workflows

## Docker Multi-Architecture Build

`docker-publish.yml` builds every `keymetrics/pm2` image for `linux/amd64` and `linux/arm64`.

### Versions

`versions.json` at the repository root is the single source of truth:

- `node`: Node.js major versions (`latest` follows the `node:<variant>` tags)
- `variants`: base image variants (`alpine`, `bookworm`, `trixie`, `slim`)
- `hardened`: Node.js majors built on Docker Hardened Images (`<major>-hardened`, `Dockerfile.hardened`)
- `bun`: Bun images, tag → `oven/bun` tag (`Dockerfile.bun`)
- `aliases`: extra tags pushed for an image (`latest-alpine` is also pushed as `latest`)

`images.jq` expands it into the build list (`jq -f images.jq versions.json`), used as the CI matrix and by `build-and-push.sh`. The PM2 version is resolved from npm at the start of each run.

Hardened images pull from `dhi.io` with the `DOCKER_USERNAME` / `DOCKER_PASSWORD` credentials; on fork pull requests (no secrets) they are skipped.

### Pipeline

For each image:

1. Build an amd64 image and load it locally
2. Run `test/test-image.sh` against it (node/pm2 versions, example-app served through `pm2-runtime`, graceful SIGTERM)
3. Build and push the multi-arch image with SBOM and provenance attestations (skipped on pull requests)
4. Report fixable critical/high CVEs with Docker Scout (informational, never blocks a release)

A failing variant does not cancel the others (`fail-fast: false`). The `ci` job aggregates all builds and is the only required status check on `master`, so changing the matrix does not require touching branch protection.

### Build Triggers

- **Push to master**: builds and publishes all images
- **Pull requests**: builds and tests, no push
- **Weekly schedule** (Monday 02:00 UTC): rebuilds to pick up Node.js and PM2 updates
- **Manual**: `gh workflow run docker-publish.yml -R keymetrics/docker-pm2`

GitHub disables scheduled workflows after 60 days without repository activity. The `keepalive` job re-enables the workflow on every scheduled run to prevent that.

## Docker Hub Description

`dockerhub-description.yml` syncs `README.md` to the Docker Hub overview of `keymetrics/pm2` whenever it changes on master (or manually with `gh workflow run dockerhub-description.yml -R keymetrics/docker-pm2`). It uses a dedicated `DOCKERHUB_DESCRIPTION_TOKEN` secret, a Docker Hub personal access token with the Read, Write, Delete scope.

### Required Secrets

- `DOCKER_USERNAME`: Docker Hub username
- `DOCKER_PASSWORD`: Docker Hub access token (Read & Write)
