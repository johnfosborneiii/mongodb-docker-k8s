#!/bin/bash

REL=$(($(cat RELEASE) + 1))

# Update Dockerfile image release
sed -i "s|\(MONGODB_IMAGE_RELEASE=\"\)[0-9]|\1$REL|g" Dockerfile

# Increment release file
sed -i "s|[0-9]|$REL|g" RELEASE

# Update Dockerfile image version
# sed -i "s|\(MONGODB_IMAGE_VERSION=\"1\.\)[0-9]|\1$REL|g" Dockerfile
