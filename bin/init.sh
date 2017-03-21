#!/bin/bash

CUR_DIRECTORY=$(dirname "${BASH_SOURCE[0]}")
SRC_DIRECTORY=$1
SRC_FILE_NAME=$SRC_DIRECTORY/Dockerfile
VER_NUM_REGEX='[0-9]+\.[0-9]+'
VERSION_REGEX='MONGODB_IMAGE_VERSION=\"'
REL_NUM_REGEX='[0-9]+'
RELEASE_REGEX='MONGODB_IMAGE_RELEASE=\"'
IMGNAME_REGEX='MONGODB_IMAGE_NAME=\"'
END_QTE_REGEX='[^\"]*'
STR_SEPERATOR='.'

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
# BASE_IMAGE=mongodb\-base\-7\/base
# BASE_IMAGE_SED=mongodb\-base\-7\\/base:$VERSION

# Update base image reference
# if [[ "$IMAGE_NAME" != "$BASE_IMAGE" ]]; then
#   sed -i "s/\(FROM\).*/\1 $BASE_IMAGE_SED/g" $SRC_FILE_NAME
# fi

# Change to source directory
pushd $SRC_DIRECTORY

# Build image context
docker build -t $IMAGE_NAME:$VERSION .

# Change to parent directory
popd
