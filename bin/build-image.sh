#!/bin/bash

STARTTIME=$(date +%s)
source "$(dirname "${BASH_SOURCE}")/lib/init.sh"

function build_image() {
  local dir=$( absolute_path "$PROJECT_IMAGE_DIRECTORY/$1" )""
  local file=${dir}/Dockerfile
  local name="$( get_dockerfile_image_name ${file} )"
  local patch=$(( $(get_dockerfile_image_release ${file}) + 1 ))
  local tag="$( get_dockerfile_image_version ${file} )"

  # Check semantic versioning
  if ! equal_to ${dir} $BASE_IMAGE_DIRECTORY && ! equal_to ${tag} $BASE_IMAGE_VERSION; then
    set_dockerfile_image_version ${file} $BASE_IMAGE_VERSION
    set_dockerfile_from_image_tag ${file} $BASE_IMAGE_VERSION
    patch=1
  elif equal_to ${dir} $BASE_IMAGE_DIRECTORY && ! equal_to ${tag} $BASE_IMAGE_VERSION; then
    set_dockerfile_image_version ${file} $BASE_IMAGE_VERSION
    patch=1
  fi

  # Increment build release
  set_dockerfile_image_release ${file} ${patch}

  pushd ${dir}

  # Build image context
  docker build -t ${name}:${tag} .

  popd
}

build_image ${1:-''}

ret=$?; ENDTIME=$(date +%s); echo "$0 took $(($ENDTIME - $STARTTIME)) seconds"; exit "$ret"
