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

function get_semantic_version() {
  local tag="$( get_commit_tag ${1:-HEAD} )"

  echo -n $(get_string_semantic_version ${tag})
}
readonly -f get_semantic_version
