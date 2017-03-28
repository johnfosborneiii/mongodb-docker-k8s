#!/bin/bash

# This script holds library functions for setting up the Docker container build environment.

function create() {
  set -o errexit
  local dir="$( absolute_path "${OS_IMG_PATH}/$1" )"
  local file="${dir}/Dockerfile"
  local name="$( get_dockerfile_image_name ${file} )"
  local patch="$(( $(get_dockerfile_image_release ${file}) + 1 ))"
  local tag="$( get_dockerfile_image_version ${file} )"

  # Check semantic versioning
  if ! equal_to_object ${dir} ${OS_IMG_BASE} && ! equal_to_object ${tag} ${OS_VERSION}; then
    set_dockerfile_image_version ${file} ${OS_VERSION}
    set_dockerfile_from_image_tag ${file} ${OS_VERSION}
  elif equal_to_object ${dir} ${OS_IMG_BASE} && ! equal_to_object ${tag} ${OS_VERSION}; then
    set_dockerfile_image_version ${file} ${OS_VERSION}
  fi

  # Increment build release
  set_dockerfile_image_release ${file} ${patch}

  pushd ${dir}

  # Build image context
  docker build -t ${name}:${tag} .

  popd
}
readonly -f create
