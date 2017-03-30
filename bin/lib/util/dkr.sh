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

function docker_start_container() {
  docker start ${1:-''} > /dev/null
}
readonly -f docker_start_container

function docker_stop_container() {
  docker stop ${1:-''} > /dev/null
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
  local ports=$(docker inspect --format='{{.Config.ExposedPorts}}' ${1:-''} | grep -o [0-9]*)
  local args=""

  for port in ${ports} ; do
    args="${args} -p ${port}:${port}"
  done

  echo -n ${args}
}
readonly -f docker_get_exposed_ports

function docker_run_container() {
  local dir="${OS_IMG_PATH}/${1-}"
  local file="${dir}/Dockerfile"
  local name="$( get_dockerfile_image_name ${file} )"
  local short_name="$( get_string_after_forward_slash ${name})"
  local tag="$( get_dockerfile_image_version ${file} )"
  local ports="$( docker_get_exposed_ports ${name}:${tag} )"

  if is_null_container ${short_name} ; then
    docker run -di ${ports} --name ${short_name} ${name}:${tag}
  elif is_running_container ${short_name} ; then
    get_message_codes ${OS_IGNORED} "docker_run_container : ${1:-''}"
  else
    get_message_codes ${OS_CHNAGED} "docker_run_container : ${1:-''}"
    docker_start_container ${short_name}
  fi
}
readonly -f docker_run_container

function is_null_container() {
  local filter="$(docker ps -aq -f name=${1-})"

  if [[ -z ${filter} ]]; then
    return 0
  fi

  return 1
}
readonly -f is_null_container

function is_running_container() {
  local filter="$(docker ps -qa -f status=running -f name=${1-})"

  if [[ ${filter} ]]; then
    return 0
  fi

  return 1
}
readonly -f is_running_container
