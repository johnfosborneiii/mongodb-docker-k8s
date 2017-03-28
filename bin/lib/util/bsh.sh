#!/bin/bash

function pushd() {
  command pushd "$@" > /dev/null
}
readonly -f pushd

function popd() {
  command popd "$@" > /dev/null
}
readonly -f popd
