#!/bin/bash

function get_commit_tag() {
  git --work-tree "${OS_ROOT}" tag --contains "${1:-HEAD}"
}
readonly -f get_commit_tag

function get_commit_hash() {
  git --work-tree "${OS_ROOT}" show -s --format=%H "${1:-HEAD}"
}
readonly -f get_commit_hash

function get_abbreviated_commit_hash() {
  git --work-tree "${OS_ROOT}" show -s --format=%h "${1:-HEAD}"
}
readonly -f get_abbreviated_commit_hash

#####################################################
# Semantic Versioning
#####################################################

function get_semantic_version() {
  local tag="$( get_commit_tag ${1:-HEAD} )"

  echo -n $(get_string_semantic_version ${tag})
}
readonly -f get_semantic_version

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
    get_status_code ${OS_CHNAGED} "save_version_vars : ${version_file}"
  fi
}
readonly -f save_version_vars

function load_version_vars() {
  local version_file=${1:-"${OS_VERSION_FILE}"}

  if ! is_null_file ${version_file} ; then
    source "${version_file}"
  else
    get_status_code ${OS_FAILURE} "load_version_vars : ${version_file}"
  fi
}
readonly -f load_version_vars