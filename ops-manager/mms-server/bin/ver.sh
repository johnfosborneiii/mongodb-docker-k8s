#!/bin/bash

REL=$(($(cat RELEASE) + 1))

# Update Dockerfile image release
sed -i "s|\(MONGODB_IMAGE_RELEASE=\"\)[0-9]*|\1$REL|g" Dockerfile

# Increment release file
echo $REL > RELEASE
