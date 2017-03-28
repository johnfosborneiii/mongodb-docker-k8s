#!/bin/bash

ENV_IMAGE_VERSION='IMAGE_VERSION'
ENV_IMAGE_RELEASE='IMAGE_RELEASE'

#####################################################
# Dockerfile
#####################################################

function get_dockerfile_image_version() {
  local line="$(get_file_first_line_match ${1:-''} ${ENV_IMAGE_VERSION})"

  echo -n $(get_string_inbetween_quotes ${line})
}
readonly -f get_dockerfile_image_version

function set_dockerfile_image_version() {
  set_file_first_line_match_string_between_quotes ${1:-''} ${ENV_IMAGE_VERSION} ${2:-''}
}
readonly -f set_dockerfile_image_version

function get_dockerfile_image_release() {
  local line="$(get_file_first_line_match ${1:-''} ${ENV_IMAGE_RELEASE})"

  echo -n $(get_string_inbetween_quotes ${line})
}
readonly -f get_dockerfile_image_release

function set_dockerfile_image_release() {
  set_file_first_line_match_string_between_quotes ${1:-''} ${ENV_IMAGE_RELEASE} ${2:-''}
}
readonly -f set_dockerfile_image_release

function get_dockerfile_image_name() {
  local line="$(get_file_first_line_match ${1:-''} 'IMAGE_NAME')"

  echo -n $(get_string_inbetween_quotes ${line})
}
readonly -f get_dockerfile_image_name

function set_dockerfile_from_image_tag() {
  set_file_first_line_match_string_after_pattern ${1:-''} 'FROM\s.*\:' ${2:-''}
}
readonly -f set_dockerfile_from_image_tag

#####################################################
# Container / Image
#####################################################

function docker_stop_container() {
  docker stop ${1:-''}
}
readonly -f docker_stop_container

function docker_remove_container() {
  docker rm ${1:-''}
}
readonly -f docker_remove_container

function docker_get_ip_address() {
  docker inspect --format='{{.NetworkSettings.IPAddress}}' ${1:-''}
}
readonly -f docker_get_ip_address

function docker_get_id() {
  docker inspect --format="{{.Id}}" ${1:-''}
}
readonly -f docker_get_id

function docker_get_exposed_ports() {
  local ports=$(docker inspect --format='{{.Config.ExposedPorts}}' ${1:-''})
}
readonly -f docker_get_exposed_ports
