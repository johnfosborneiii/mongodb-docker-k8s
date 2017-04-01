#!/bin/bash

# This script is for set, save and load semantic versioning properties.

function get_version_vars() {
  load_version_vars "${OS_VERSION_FILE}"

  OS_GIT_COMMIT="${OS_GIT_COMMIT:-"$( get_commit_hash )"}"
  OS_SEMANTIC_VERSION="${OS_SEMANTIC_VERSION:-"$( get_semantic_version )"}"
  IFS='.' read -a OS_SEMANTIC_VERSION_ARRAY <<< "${OS_SEMANTIC_VERSION}"
  OS_SEMANTIC_VERSION_MAJOR="${OS_SEMANTIC_VERSION_MAJOR:-"${OS_SEMANTIC_VERSION_ARRAY[0]}"}"
  OS_SEMANTIC_VERSION_MINOR="${OS_SEMANTIC_VERSION_MINOR:-"${OS_SEMANTIC_VERSION_ARRAY[1]}"}"
  OS_VERSION="${OS_VERSION:-"$( get_version )"}"
  OS_SEMANTIC_VERSION_PATCH="${OS_SEMANTIC_VERSION_PATCH:-"$(( ${OS_SEMANTIC_VERSION_ARRAY[2]} + 1 ))"}"

  save_version_vars "${OS_VERSION_FILE}"
}
readonly -f get_version_vars

function get_version() {
  echo -n "${OS_SEMANTIC_VERSION_MAJOR}.${OS_SEMANTIC_VERSION_MINOR}"
}

function save_version_vars() {
  local version_file=${1:-"${OS_VERSION_FILE}"}

  if is_null_file ${version_file} "save_version_vars" ; then
cat <<EOF >"${version_file}"
OS_GIT_COMMIT='${OS_GIT_COMMIT}'
OS_SEMANTIC_VERSION='${OS_SEMANTIC_VERSION}'
OS_VERSION='${OS_VERSION}'
OS_SEMANTIC_VERSION_MAJOR='${OS_SEMANTIC_VERSION_MAJOR}'
OS_SEMANTIC_VERSION_MINOR='${OS_SEMANTIC_VERSION_MINOR}'
OS_SEMANTIC_VERSION_PATCH='${OS_SEMANTIC_VERSION_PATCH}'
EOF
    get_message_codes ${OS_CHNAGED} "save_version_vars : ${version_file}"
  fi
}
readonly -f save_version_vars

function load_version_vars() {
  local version_file=${1:-"${OS_VERSION_FILE}"}

  if ! is_null_file ${version_file} ; then
    source "${version_file}"
  else
    get_message_codes ${OS_FAILURE} "load_version_vars : ${version_file}"
  fi
}
readonly -f load_version_vars
