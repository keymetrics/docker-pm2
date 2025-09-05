#!/bin/bash

# Build and push all PM2 Docker images
# This script builds and pushes all variants for all Node.js versions

set -e

# Handle Ctrl+C gracefully
trap 'echo -e "\n${RED}[INFO]${NC} Build process interrupted by user. Exiting..."; exit 130' SIGINT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Docker registry
REGISTRY="keymetrics/pm2"

# Versions and variants
declare -A versions
versions['latest']='alpine|bookworm|bullseye|buster|slim'
versions['24']='alpine|bookworm|bullseye|slim'
versions['22']='alpine|bookworm|bullseye|slim'
versions['20']='alpine|bookworm|bullseye|buster|slim'
versions['18']='alpine|bookworm|bullseye|buster|slim'

# Function to log with color
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to build and push a single image
build_and_push() {
    local version=$1
    local variant=$2
    local tag="${version}-${variant}"
    local dockerfile_path="./tags/${version}/${variant}/Dockerfile"
    local image_name="${REGISTRY}:${tag}"
    
    log_info "Building ${image_name}..."
    
    if [ ! -f "$dockerfile_path" ]; then
        log_error "Dockerfile not found: $dockerfile_path"
        return 1
    fi
    
    # Build the image
    if docker build -t "$image_name" "./tags/${version}/${variant}/"; then
        log_info "Successfully built ${image_name}"
        
        # Push the image
        log_info "Pushing ${image_name}..."
        if docker push "$image_name"; then
            log_info "Successfully pushed ${image_name}"
        else
            log_error "Failed to push ${image_name}"
            return 1
        fi
    else
        log_error "Failed to build ${image_name}"
        return 1
    fi
}

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    log_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if user is logged in to Docker Hub
if ! docker info | grep -q "Username"; then
    log_warn "You may not be logged in to Docker Hub. Run 'docker login' if needed."
fi

echo "========================================="
echo "  PM2 Docker Images Build & Push Script"
echo "========================================="
echo ""
log_info "Starting build and push process..."
echo ""

# Build and push all images
total_images=0
successful_builds=0
failed_builds=0

for version in "${!versions[@]}"; do
    variants=(${versions[$version]//|/ })
    for variant in "${variants[@]}"; do
        total_images=$((total_images + 1))
        echo ""
        log_info "Processing ${version}-${variant} (${total_images})"
        echo "----------------------------------------"
        
        if build_and_push "$version" "$variant"; then
            successful_builds=$((successful_builds + 1))
        else
            failed_builds=$((failed_builds + 1))
        fi
    done
done

echo ""
echo "========================================="
echo "  Build Summary"
echo "========================================="
echo "Total images: $total_images"
echo -e "Successful: ${GREEN}$successful_builds${NC}"
echo -e "Failed: ${RED}$failed_builds${NC}"

if [ $failed_builds -eq 0 ]; then
    log_info "All images built and pushed successfully!"
    exit 0
else
    log_error "$failed_builds image(s) failed to build or push"
    exit 1
fi