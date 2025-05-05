#!/bin/bash
set -e

# This script is specifically for building multi-architecture Docker images
# It does NOT increment the version number as that is handled by build-orch-node.sh
# This script is meant to be run after build-orch-node.sh to create the full release
# with support for both AMD64 and ARM64 architectures.

# Get current version from package.json
CURRENT_VERSION=$(grep -m 1 '"version":' package.json | cut -d'"' -f4)
echo "Building multi-architecture images for version: $CURRENT_VERSION"

# Create and use a new builder instance
docker buildx create --name orch-node-builder --use || true

# Build and push multi-architecture images
echo "Building multi-architecture images for gridlocknetwork/orch-node:$CURRENT_VERSION"
docker buildx build --platform linux/amd64,linux/arm64 \
    -t gridlocknetwork/orch-node:$CURRENT_VERSION \
    -t gridlocknetwork/orch-node:latest \
    --push .

echo "Successfully built and pushed multi-architecture images for gridlocknetwork/orch-node:$CURRENT_VERSION and gridlocknetwork/orch-node:latest" 