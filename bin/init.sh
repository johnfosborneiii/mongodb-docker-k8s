#!/bin/bash

CUR_DIRECTORY=$(dirname "${BASH_SOURCE[0]}")
SRC_DIRECTORY=$1
SRC_FILE_NAME=$SRC_DIRECTORY/Dockerfile
IMGBASE_REGEX='mongodb\-base\-7\/base'
VER_NUM_REGEX='[0-9]+\.[0-9]+'
VERSION_REGEX='MONGODB_IMAGE_VERSION=\"'
REL_NUM_REGEX='[0-9]+'
RELEASE_REGEX='MONGODB_IMAGE_RELEASE=\"'
IMGNAME_REGEX='MONGODB_IMAGE_NAME=\"'
IMGFROM_REGEX='FROM\s'
END_QTE_REGEX='[^\"]*'
END_COL_REGEX='[^\:]*'
STR_SEPERATOR='.'

# Quiet pushd
pushd () {
    command pushd "$@" > /dev/null
}

# Quiet popd
popd () {
    command popd "$@" > /dev/null
}

# Check source directory
if [[ ! -d $SRC_DIRECTORY ]]; then
  echo "pwd: No such directory"
  exit 1
fi

# Check Dockerfile
if [[ ! -f $SRC_FILE_NAME ]]; then
  echo "Dockerfile: No such file"
  exit 1
fi

# Get version pattern
# VERSION=$(egrep -o $VERSION_REGEX$END_QTE_REGEX $SRC_FILE_NAME | egrep -o $VER_NUM_REGEX)
VERSION=$(cat $CUR_DIRECTORY/../VERSION)

# Check version
if [[ -z $VERSION ]]; then
  echo "regex: Version not found"
  exit 1
fi

# Split version pattern
# IFS=$STR_SEPERATOR read -a VERSION_ARRAY <<< $VERSION

# Set major value
# MAJOR=${VERSION_ARRAY[0]}

# Set minor value
# MINOR=${VERSION_ARRAY[1]}

# Get release pattern
RELEASE=$(egrep -o $RELEASE_REGEX$END_QTE_REGEX $SRC_FILE_NAME | egrep -o $REL_NUM_REGEX)

# Check release
if [[ -z $RELEASE ]]; then
  echo "regex: Release not found"
  exit 1
fi

# Set patch value
PATCH=$(($RELEASE + 1))

# Debug semantic version
# echo "$MAJOR.$MINOR.$PATCH"

# Update Dockerfile image version
sed -i "s/\($VERSION_REGEX\)$END_QTE_REGEX/\1$VERSION/g" $SRC_FILE_NAME

# Update Dockerfile image release
sed -i "s/\($RELEASE_REGEX\)$END_QTE_REGEX/\1$PATCH/g" $SRC_FILE_NAME

# Get image name pattern
IMAGE_NAME=$(egrep -o $IMGNAME_REGEX$END_QTE_REGEX $SRC_FILE_NAME | egrep -o $END_QTE_REGEX\$)

# Update Dockerfile FROM
if [[ "$IMAGE_NAME" != $IMGBASE_REGEX ]]; then
  sed -i "s/\($IMGFROM_REGEX$END_COL_REGEX\).*/\1\\:$VERSION/g" $SRC_FILE_NAME
fi

# Change to source directory
pushd $SRC_DIRECTORY

# Build image context
docker build -t $IMAGE_NAME:$VERSION .

# Change to parent directory
popd
