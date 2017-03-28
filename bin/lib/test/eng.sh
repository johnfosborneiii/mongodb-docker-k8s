#!/bin/bash

# This script contains functions used for Docker unit testing.

# function test_cleanup() {
#   for cidfile in $CIDFILE_DIR/* ; do
#     CONTAINER=$(cat $cidfile)
#
#     echo "Stopping and removing container $CONTAINER..."
#     docker stop $CONTAINER
#     docker rm $CONTAINER
#     rm $cidfile
#     echo "Done."
#   done
#   rmdir $CIDFILE_DIR
# }
# trap test_cleanup EXIT SIGINT

function test_connection() {
  local name=$1 ; shift
  CONTAINER_IP=$(get_container_ip $name)
  echo "  Testing MongoDB connection to $CONTAINER_IP..."
  local max_attempts=20
  local sleep_time=2
  for i in $(seq $max_attempts); do
    echo "    Trying to connect..."
    set +e
    mongo_cmd "db.getSiblingDB('test_database');"
    status=$?
    set -e
    if [[ $status -eq 0 ]]; then
      echo "  Success!"
      return 0
    fi
    sleep $sleep_time
  done
  echo "  Giving up: Failed to connect. Logs:"
  docker logs $(get_cid $name)
  return 1
}
readonly -f test_connection
