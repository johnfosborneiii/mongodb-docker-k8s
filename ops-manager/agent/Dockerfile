# Dockerizing MongoDB: Dockerfile for building Ops Manager images.
# Based on mongodb-base-7/base:1.1, installs MMA via an archive (.tar) file.

FROM mongodb-base-7/base:1.1

# Environment variables
ENV MONGODB_IMAGE_NAME="mongodb-base-7/mma" \
    MONGODB_IMAGE_VERSION="1.1" \
    MONGODB_IMAGE_RELEASE="1"

# Build labels
LABEL Name="$MONGODB_IMAGE_NAME" \
      Version="$MONGODB_IMAGE_VERSION" \
      Release="$MONGODB_IMAGE_RELEASE" \
      Architecture="x86_64" \
      BZComponent="mongodb-base-7-mma-docker" \
      Authors="John Osborne <johnfosborneiii@gmail.com>, Michael Surbey <msurbey@redhat.com>"
