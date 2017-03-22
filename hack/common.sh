#!/bin/bash

# This script provides common script functions for the hacks

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

function d_exists() {
  if [[ ! -d $1 ]]; then
    echo $2": Directory does not exist"
    exit 1
  fi
}

function f_exists() {
  if [[ ! -f $1 ]]; then
    echo $2": File does not exist"
    exit 1
  fi
}

function s_exists() {
  if [[ -z $1 ]]; then
    echo $2": String does not exist"
    exit 1
  fi
}

function get_version() {
  echo -n $(cat $OS_ROOT/images/VERSION)
}

function get_dockerfile_image_version() {
  echo -n $(egrep -o $VERSION_REGEX$END_QTE_REGEX $1 | egrep -o $VER_NUM_REGEX)
}

function get_dockerfile_image_release() {
  echo -n $(egrep -o $RELEASE_REGEX$END_QTE_REGEX $1 | egrep -o $REL_NUM_REGEX)
}

function get_dockerfile_image_name() {
  echo -n $(egrep -o $IMGNAME_REGEX$END_QTE_REGEX $1 | egrep -o $END_QTE_REGEX\$)
}

function build_image() {
  DOCKERFILE=$OS_ROOT/images/$1/Dockerfile
  VERSION=$(get_version)
  PATCH=$(($(get_dockerfile_image_release $DOCKERFILE) + 1))
  IMAGE_NAME=$(get_dockerfile_image_name $DOCKERFILE)

  f_exists $DOCKERFILE "Dockerfile"

  # Update Dockerfile image version
  sed -i "s/\($VERSION_REGEX\)$END_QTE_REGEX/\1$VERSION/g" $DOCKERFILE

  # Update Dockerfile image release
  sed -i "s/\($RELEASE_REGEX\)$END_QTE_REGEX/\1$PATCH/g" $DOCKERFILE

  # Update FROM
  if [[ "$IMAGE_NAME" != $IMGBASE_REGEX ]]; then
    sed -i "s/\($IMGFROM_REGEX$END_COL_REGEX\).*/\1\\:$VERSION/g" $DOCKERFILE
  fi

  # Change to source directory
  pushd $OS_ROOT/images/$1

  # Build image context
  docker build -t $IMAGE_NAME:$VERSION .

  # Change to parent directory
  popd
}
