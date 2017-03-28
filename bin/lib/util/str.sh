#!/bin/bash

INBETWEEN_QUOTES='.*\"\(.*\)\".*'
SEMANTIC_VERSION='[^0-9]*\(\([0-9]*\.[0-9]*\.[0-9]*\)\{1\}\).*'

function get_string_inbetween_quotes() {
  expr "${1:-''}" : ${INBETWEEN_QUOTES}
}
readonly -f get_string_inbetween_quotes

function get_string_semantic_version() {
  expr "${1:-''}" : ${SEMANTIC_VERSION}
}
readonly -f get_string_semantic_version

function is_null_string() {
  if [[ -z ${1:-''} ]] ; then
    return 0
  else
    get_error_message ${OS_FAILURE} "${2:-''}:${1:-''}"
  fi

  return 1
}
readonly -f is_null_string
