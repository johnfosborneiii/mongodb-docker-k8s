#!/bin/bash

SRC_DIRECTORY=$1
SRC_FILE_NAME=$SRC_DIRECTORY/Dockerfile
VER_NUM_REGEX='[0-9]+\.[0-9]+'
VERSION_REGEX='MONGODB_IMAGE_VERSION=\"'
REL_NUM_REGEX='[0-9]+'
RELEASE_REGEX='MONGODB_IMAGE_RELEASE=\"'
IMGNAME_REGEX='MONGODB_IMAGE_NAME=\"'
END_QTE_REFEX='[^\"]*'
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
VERISON=$(egrep -o $VERSION_REGEX$END_QTE_REFEX $SRC_FILE_NAME | egrep -o $VER_NUM_REGEX)

# Check version
if [[ -z $VERISON ]]; then
  echo "regex: Version not found"
  exit 1
fi

# Split version pattern
IFS=$STR_SEPERATOR read -a VERSION_ARRAY <<< $VERISON

# Set major value
MAJOR=${VERSION_ARRAY[0]}

# Set minor value
MINOR=${VERSION_ARRAY[1]}

# Get release pattern
RELEASE=$(egrep -o $RELEASE_REGEX$END_QTE_REFEX $SRC_FILE_NAME | egrep -o $REL_NUM_REGEX)

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
sed -i "s/\($VERSION_REGEX\)$END_QTE_REFEX/\1$MAJOR.$MINOR/g" $SRC_FILE_NAME

# Update Dockerfile image release
sed -i "s/\($RELEASE_REGEX\)$END_QTE_REFEX/\1$PATCH/g" $SRC_FILE_NAME

# Get image name pattern
IMAGE_NAME=$(egrep -o $IMGNAME_REGEX$END_QTE_REFEX $SRC_FILE_NAME | egrep -o $END_QTE_REFEX\$)

# Change to source directory
pushd $SRC_DIRECTORY

# Build image context
docker build -t $IMAGE_NAME:$MAJOR.$MINOR .

# Change to parent directory
popd
