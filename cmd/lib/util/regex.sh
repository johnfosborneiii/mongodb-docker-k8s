#!/bin/bash

function get_string_inbetween_quotes() {
  expr "${1:-''}" : ${INBETWEEN_QUOTES}
}
readonly -f get_string_inbetween_quotes

function get_string_semantic_version() {
  expr "${1:-''}" : ${SEMANTIC_VERSION}
}
readonly -f get_string_semantic_version

function get_string_after_forward_slash() {
  expr "${1:-''}" : ${AFTER_FORWARD_SLASH}
}
