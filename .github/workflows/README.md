# GitHub Actions Workflows

## Docker Multi-Architecture Build

`docker-publish.yml` builds every `keymetrics/pm2` image for `linux/amd64` and `linux/arm64`.

### Versions

`versions.json` at the repository root is the single source of truth:

- `node`: Node.js major versions (`latest` follows the `node:<variant>` tags)
- `variants`: base image variants (`alpine`, `bookworm`, `trixie`, `slim`)
- `aliases`: extra tags pushed for an image (`latest-alpine` is also pushed as `latest`)

Every image is built from the root `Dockerfile` with `NODE_TAG` and `PM2_VERSION` build args. The PM2 version is resolved from npm at the start of each run.

### Pipeline

For each Node version × variant:

1. Build an amd64 image and load it locally
2. Run `test/test-image.sh` against it (node/pm2 versions, example-app served through `pm2-runtime`, graceful SIGTERM)
3. Build and push the multi-arch image with SBOM and provenance attestations (skipped on pull requests)
4. Report fixable critical/high CVEs with Docker Scout (informational, never blocks a release)

A failing variant does not cancel the others (`fail-fast: false`).

### Build Triggers

- **Push to master**: builds and publishes all images
- **Pull requests**: builds and tests, no push
- **Weekly schedule** (Monday 02:00 UTC): rebuilds to pick up Node.js and PM2 updates
- **Manual**: `gh workflow run docker-publish.yml -R keymetrics/docker-pm2`

GitHub disables scheduled workflows after 60 days without repository activity. The `keepalive` job re-enables the workflow on every scheduled run to prevent that.

### Required Secrets

- `DOCKER_USERNAME`: Docker Hub username
- `DOCKER_PASSWORD`: Docker Hub access token (Read & Write)
