#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

source bin/env.sh

# Update Dockerfile image version
sed -i "s/\($VERSION_REGEX\)$END_QTE_REGEX/\1$VERSION/g" $SRC_FILE_NAME

# Update Dockerfile image release
sed -i "s/\($RELEASE_REGEX\)$END_QTE_REGEX/\1$PATCH/g" $SRC_FILE_NAME

# Update FROM
if [[ "$IMAGE_NAME" != $IMGBASE_REGEX ]]; then
  sed -i "s/\($IMGFROM_REGEX$END_COL_REGEX\).*/\1\\:$VERSION/g" $SRC_FILE_NAME
fi

# Change to source directory
pushd $SRC_DIRECTORY

# Build image context
docker build -t $IMAGE_NAME:$VERSION .

# Change to parent directory
popd
