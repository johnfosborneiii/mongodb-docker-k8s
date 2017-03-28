#!/bin/bash

# This script provides constants for the binary build process.
readonly OS_BIN_PATH="${OS_BIN_PATH:-"${OS_ROOT}/bin"}"
readonly OS_IMG_PATH="${OS_IMG_PATH:-"${OS_ROOT}/img"}"
readonly OS_IMG_BASE="${OS_IMG_BASE:-"${OS_IMG_PATH}/base"}"

readonly OS_VERSION_PATH="${OS_VERSION_PATH:-"/tmp"}"
readonly OS_VERSION_FILE="${OS_VERSION_FILE:-"${OS_VERSION_PATH}/os-version-defs"}"

readonly OS_SUCCESS="0"
readonly OS_FAILURE="1"
readonly OS_CHNAGED="2"
readonly OS_IGNORED="3"
