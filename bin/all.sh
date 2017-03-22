#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

CUR_DIRECTORY=$(dirname "${BASH_SOURCE[0]}")

SRC_DIRECTORY=$1
SRC_FILE_NAME=$SRC_DIRECTORY/Dockerfile
VER_FILE_NAME=$CUR_DIRECTORY/../VERSION

IMGNAME_REGEX='IMAGE_NAME=\"'
IMGBASE_REGEX='mongodb\-base\-7\/base'
IMGFROM_REGEX='FROM\s'

VERSION_REGEX='IMAGE_VERSION=\"'
VER_NUM_REGEX='[0-9]+\.[0-9]+'

RELEASE_REGEX='IMAGE_RELEASE=\"'
REL_NUM_REGEX='[0-9]+'

END_QTE_REGEX='[^\"]*'
END_COL_REGEX='[^\:]*'

STR_SEPERATOR='.'

# Quiet pushd
function pushd() {
  command pushd "$@" > /dev/null
}

# Quiet popd
function popd() {
  command popd "$@" > /dev/null
}

# Get Docker image version pattern
function get_image_version() {
  echo -n $(egrep -o $VERSION_REGEX$END_QTE_REGEX $SRC_FILE_NAME | egrep -o $VER_NUM_REGEX)
}

# Get Docker image release pattern
function get_image_release() {
  echo -n $(egrep -o $RELEASE_REGEX$END_QTE_REGEX $SRC_FILE_NAME | egrep -o $REL_NUM_REGEX)
}

# Get Docker image name pattern
function get_image_name() {
  echo -n $(egrep -o $IMGNAME_REGEX$END_QTE_REGEX $SRC_FILE_NAME | egrep -o $END_QTE_REGEX\$)
}

function test_layout() {
  if [[ ! -d $SRC_DIRECTORY ]]; then
    echo "pwd: No such directory"
    exit 1
  elif [[ ! -f $SRC_FILE_NAME ]]; then
    echo "Dockerfile: No such file"
    exit 1
  elif [[ ! -f $VER_FILE_NAME ]]; then
    echo "VERSION: No such file"
    exit 1
  elif [[ -z $(get_image_version) ]]; then
    echo "IMAGE_VERSION: Regex not found"
    exit 1
  elif [[ -z $(get_image_release) ]]; then
    echo "IMAGE_RELEASE: Regex not found"
    exit 1
  elif [[ -z $(get_image_name) ]]; then
    echo "IMAGE_NAME: Regex not found"
    exit 1
  fi
}

# Verify layout
test_layout

# Set version
VERSION=$(cat $VER_FILE_NAME)

# Set patch
PATCH=$(($(get_image_release) + 1))

# Set name
IMAGE_NAME=$(get_image_name)
