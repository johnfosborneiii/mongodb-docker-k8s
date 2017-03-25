#!/bin/bash

# Provides common script functions

PROJECT_IMAGE_DIRECTORY=$OS_ROOT/imgs
PROJECT_VERSION_FILE=$OS_ROOT/VERSION

BASE_IMAGE_DIRECTORY="$( absolute_path "$PROJECT_IMAGE_DIRECTORY/base" )"
BASE_IMAGE_DOCKERFILE=$BASE_IMAGE_DIRECTORY/Dockerfile
BASE_IMAGE_VERSION="$(cat $PROJECT_VERSION_FILE)"

IMAGE_NAME_REGEX='IMAGE_NAME'
IMAGE_VERSION_REGEX='IMAGE_VERSION'
IMAGE_RELEASE_REGEX='IMAGE_RELEASE'
IMAGE_FROM_REGEX='FROM\s.*\:'

function equal_to() {
  if [[ "${1:-''}" == "${2:-''}" ]]; then
    # 0 = true
    return 0
  else
    # 1 = false
    return 1
  fi
}

function get_dockerfile_image_version() {
  local line=$(get_file_first_line_match ${1:-''} $IMAGE_VERSION_REGEX)

  echo -n $(get_string_between_quotes "${line}")
}

function set_dockerfile_image_version() {
  set_file_first_line_match_string_between_quotes ${1:-''} $IMAGE_VERSION_REGEX ${2:-''}
}

function get_dockerfile_image_release() {
  local line=$(get_file_first_line_match ${1:-''} $IMAGE_RELEASE_REGEX)

  echo -n $(get_string_between_quotes "${line}")
}

function set_dockerfile_image_release() {
  set_file_first_line_match_string_between_quotes ${1:-''} $IMAGE_RELEASE_REGEX ${2:-''}
}

function get_dockerfile_image_name() {
  local line="$(get_file_first_line_match ${1:-''} $IMAGE_NAME_REGEX)"

  echo -n $(get_string_between_quotes "${line}")
}

function set_dockerfile_from_image_tag() {
  set_file_first_line_match_string_after_pattern ${1:-''} $IMAGE_FROM_REGEX ${2:-''}
}
