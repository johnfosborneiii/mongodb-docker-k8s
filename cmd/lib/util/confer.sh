#!/bin/bash

function equal_to_object() {
	if [[ ${1:-''} == ${2:-''} ]]; then
		return 0
	fi

	return 1
}
readonly -f equal_to_object

function is_null_file() {
  if [[ ! -s ${1:-''} ]] ; then
    return 0
  fi

  return 1
}
readonly -f is_null_file

function is_null_string() {
  if [[ -z ${1:-''} ]] ; then
    return 0
  fi

  return 1
}
readonly -f is_null_string
