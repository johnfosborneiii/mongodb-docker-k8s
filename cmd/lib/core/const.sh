#!/bin/bash

readonly OS_IMG_PATH="${OS_IMG_PATH:-"${OS_ROOT}/img"}"
readonly OS_IMG_BASE="${OS_IMG_BASE:-"${OS_IMG_PATH}/base"}"

readonly OS_VERSION_PATH="${OS_VERSION_PATH:-"/tmp"}"
readonly OS_VERSION_FILE="${OS_VERSION_FILE:-"${OS_VERSION_PATH}/os-version-defs"}"

readonly OS_SUCCESS="0"
readonly OS_FAILURE="1"
readonly OS_CHNAGED="2"
readonly OS_IGNORED="3"

readonly OPT_BLDC="1"
readonly OPT_RUNC="2"
readonly OPT_TEST="3"

readonly ENV_IMAGE_VERSION='IMAGE_VERSION'
readonly ENV_IMAGE_RELEASE='IMAGE_RELEASE'
readonly ENV_IMAGE_NAME='IMAGE_NAME'

readonly INBETWEEN_QUOTES='.*\"\(.*\)\".*'
readonly SEMANTIC_VERSION='[^0-9]*\(\([0-9]*\.[0-9]*\.[0-9]*\)\{1\}\).*'
readonly AFTER_FORWARD_SLASH='.*/\(\w*\)'
