#!/bin/bash
# Smoke test a keymetrics/pm2 image by running example-app inside it.
# Usage: test/test-image.sh <image> [expected-pm2-version]

set -euo pipefail

IMAGE=${1:?usage: test/test-image.sh <image> [expected-pm2-version]}
EXPECTED_PM2=${2:-}
PORT=${PORT:-3999}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
CID=""

fail() {
  echo -e "\033[31m ✘ \033[0m$1"
  [ -n "$CID" ] && docker logs "$CID" 2>&1 | tail -50
  exit 1
}

success() {
  echo -e "\033[32m ✔ \033[0m$1"
}

cleanup() {
  [ -n "$CID" ] && docker rm -f "$CID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "Testing ${IMAGE}"

NODE_VERSION=$(docker run --rm "$IMAGE" node -v) || fail "node -v failed"
success "node ${NODE_VERSION}"

PM2_VERSION=$(docker run --rm "$IMAGE" pm2 -v | tail -1) || fail "pm2 -v failed"
if [ -n "$EXPECTED_PM2" ] && [ "$PM2_VERSION" != "$EXPECTED_PM2" ]; then
  fail "pm2 ${PM2_VERSION}, expected ${EXPECTED_PM2}"
fi
success "pm2 ${PM2_VERSION}"

CID=$(docker run -d -p "${PORT}:3000" -v "${ROOT}/example-app:/app:ro" -w /app "$IMAGE")

BODY=""
for _ in $(seq 1 30); do
  BODY=$(curl -fs "http://localhost:${PORT}/" || true)
  [ "$BODY" = "hey" ] && break
  sleep 1
done
[ "$BODY" = "hey" ] || fail "example-app did not answer on port ${PORT}"
success "example-app answers through pm2-runtime"

ONLINE=$(docker exec "$CID" pm2 jlist | node -e '
  const list = JSON.parse(require("fs").readFileSync(0, "utf8"))
  const names = new Set(list.filter(p => p.pm2_env.status === "online").map(p => p.name))
  console.log(names.size)
')
[ "$ONLINE" = "2" ] || fail "expected api and worker online, got ${ONLINE} app(s)"
success "api and worker online"

docker stop -t 10 "$CID" >/dev/null || fail "container did not stop"
EXIT_CODE=$(docker inspect -f '{{.State.ExitCode}}' "$CID")
[ "$EXIT_CODE" = "0" ] || fail "container exited with code ${EXIT_CODE} on SIGTERM"
success "graceful shutdown on SIGTERM"
