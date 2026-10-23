#!/bin/bash

# Build, test and push all PM2 Docker images from a workstation.
# CI does the same through .github/workflows/docker-publish.yml; both read versions.json.
#
# Usage: ./build-and-push.sh            build, test and push everything
#        ./build-and-push.sh --no-push  build and test only
#        ./build-and-push.sh 22-alpine  restrict to some tags

set -euo pipefail

trap 'echo -e "\n${RED}[INFO]${NC} Build process interrupted by user. Exiting..."; exit 130' SIGINT

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REGISTRY="keymetrics/pm2"
PLATFORMS="linux/amd64,linux/arm64"
cd "$(dirname "$0")"

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

PUSH=1
ONLY=()
for arg in "$@"; do
  case "$arg" in
    --no-push) PUSH=0 ;;
    *) ONLY+=("$arg") ;;
  esac
done

command -v jq >/dev/null || { log_error "jq is required"; exit 1; }
docker info >/dev/null 2>&1 || { log_error "Docker is not running. Please start Docker and try again."; exit 1; }

PM2_VERSION=$(npm view pm2 version)
log_info "PM2 version: ${PM2_VERSION}"

build_test_push() {
  local version=$1 variant=$2
  local tag="${version}-${variant}"
  local node_tag="$tag"
  [ "$version" = "latest" ] && node_tag="$variant"

  local tags=(-t "${REGISTRY}:${tag}")
  while read -r alias; do
    [ -n "$alias" ] && tags+=(-t "${REGISTRY}:${alias}")
  done < <(jq -r --arg t "$tag" '.aliases[$t] // [] | .[]' versions.json)

  log_info "Building ${REGISTRY}:${tag} (node:${node_tag})"
  docker buildx build --pull --load \
    --build-arg NODE_TAG="$node_tag" --build-arg PM2_VERSION="$PM2_VERSION" \
    -t "pm2-test:${tag}" . || return 1

  bash test/test-image.sh "pm2-test:${tag}" "$PM2_VERSION" || return 1

  if [ "$PUSH" = 1 ]; then
    log_info "Pushing ${REGISTRY}:${tag} and aliases"
    docker buildx build --pull --push --platform "$PLATFORMS" \
      --build-arg NODE_TAG="$node_tag" --build-arg PM2_VERSION="$PM2_VERSION" \
      "${tags[@]}" . || return 1
  fi
}

total=0
ok=0
failed=()

for version in $(jq -r '.node[]' versions.json); do
  for variant in $(jq -r '.variants[]' versions.json); do
    tag="${version}-${variant}"
    if [ ${#ONLY[@]} -gt 0 ] && [[ ! " ${ONLY[*]} " =~ " ${tag} " ]]; then
      continue
    fi
    total=$((total + 1))
    echo "----------------------------------------"
    if build_test_push "$version" "$variant"; then
      ok=$((ok + 1))
    else
      log_error "${tag} failed"
      failed+=("$tag")
    fi
  done
done

echo "========================================="
echo "Total images: $total"
echo -e "Successful: ${GREEN}${ok}${NC}"
echo -e "Failed: ${RED}${#failed[@]}${NC} ${failed[*]:-}"

[ ${#failed[@]} -eq 0 ]
