#!/bin/bash

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

function mongo_cmd() {
  docker run --rm $IMAGE_NAME mongo "$DB" --host $CONTAINER_IP -u "$USER" -p "$PASS" --eval "${@}"
}

function mongo_admin_cmd() {
  docker run --rm $IMAGE_NAME mongo admin --host $CONTAINER_IP -u admin -p "$ADMIN_PASS" --eval "${@}"
}

function test_mongo() {
  echo "  Testing MongoDB"
  if [[ -v ADMIN_PASS ]]; then
    echo "  Testing Admin user privileges"
    mongo_admin_cmd "db=db.getSiblingDB('${DB}');db.removeUser('${USER}');"
    mongo_admin_cmd "db=db.getSiblingDB('${DB}');db.createUser({user:'${USER}',pwd:'${PASS}',roles:['readWrite','userAdmin','dbAdmin']});"
    mongo_admin_cmd "db=db.getSiblingDB('${DB}');db.testData.insert({x:0});"
    mongo_cmd "db.createUser({user:'test_user2',pwd:'test_password2',roles:['readWrite']});"
  fi
  echo "  Testing user privileges"
  mongo_cmd "db.testData.insert({ y : 1 });"
  mongo_cmd "db.testData.insert({ z : 2 });"
  mongo_cmd "db.testData.find().forEach(printjson);"
  mongo_cmd "db.testData.count();"
  mongo_cmd "db.testData.drop();"
  mongo_cmd "db.dropDatabase();"
  echo "  Success!"
}

function test_config_option() {
  local env_var=$1 ; shift
  local setting=$1 ; shift
  local value=$1 ; shift

  local name="configuration_${setting}"

  # If $value is a string, it needs to be in simple quotes ''.
  DOCKER_ARGS="
  -e MONGODB_DATABASE=db
  -e MONGODB_USER=user
  -e MONGODB_PASSWORD=password
  -e MONGODB_ADMIN_PASSWORD=adminPassword
  -e $env_var=${value//\'/}
  "
  create_container ${name} ${DOCKER_ARGS}

  # need to set these because `mongo_cmd` relies on global variables
  USER=user
  PASS=password
  DB=db

  test_connection ${name}

  # If nothing is found, grep returns 1 and test fails.
  docker exec $(get_cid $name) bash -c "cat /etc/mongod.conf" | grep -q "$setting = $value"

  docker stop $(get_cid ${name})
}

function test_text_search_enabled() {
  DOCKER_ARGS="
  -e MONGODB_DATABASE=db
  -e MONGODB_USER=user
  -e MONGODB_PASSWORD=password
  -e MONGODB_ADMIN_PASSWORD=adminPassword
  -e MONGODB_TEXT_SEARCH_ENABLED=true
  "
  local name=test_text_search
  create_container ${name} ${DOCKER_ARGS}
  test_connection ${name}
  docker stop $(get_cid ${name})
}

function run_configuration_tests() {
  echo "  Testing image configuration settings"
  test_config_option MONGODB_NOPREALLOC noprealloc true
  test_config_option MONGODB_SMALLFILES smallfiles true
  test_config_option MONGODB_QUIET quiet true
  test_text_search_enabled
  echo "  Success!"
}

wait_for_cid() {
  local max_attempts=10
  local sleep_time=1
  local attempt=1
  local result=1
  while [ $attempt -le $max_attempts ]]; do
    [ -f $cid_file ] && [ -s $cid_file ] && break
    echo "Waiting for container start..."
    attempt=$(( $attempt + 1 ))
    sleep $sleep_time
  done
}

function assert_login_access() {
  local USER=$1 ; shift
  local PASS=$1 ; shift
  local success=$1 ; shift

  if mongo_cmd 'db.version()' ; then
    if $success ; then
      echo "    $USER($PASS) access granted as expected"
      return
    fi
  else
    if ! $success ; then
      echo "    $USER($PASS) access denied as expected"
      return
    fi
  fi
  echo "    $USER($PASS) login assertion failed"
  exit 1
}

function run_tests() {
  local name=$1 ; shift
  envs="-e MONGODB_USER=$USER -e MONGODB_PASSWORD=$PASS -e MONGODB_DATABASE=$DB"
  if [[ -v ADMIN_PASS ]]; then
    envs="$envs -e MONGODB_ADMIN_PASSWORD=$ADMIN_PASS"
  fi
  create_container $name $envs
  CONTAINER_IP=$(get_container_ip $name)
  test_connection $name
  test_mongo $name
}

function run_change_password_test() {
  local name="change_password"
  local database='db'
  local user='user'
  local password='password'
  local admin_password='adminPassword'
  local volume_dir

  volume_dir=`mktemp -d --tmpdir mongodb-testdata.XXXXX`
  chmod a+rwx ${volume_dir}

  DOCKER_ARGS="
  -e MONGODB_DATABASE=${database}
  -e MONGODB_USER=${user}
  -e MONGODB_PASSWORD=${password}
  -e MONGODB_ADMIN_PASSWORD=${admin_password}
  -v ${volume_dir}:/var/lib/mongodb/data:Z
  "

  create_container ${name} ${DOCKER_ARGS}

  # need to set these because `mongo_cmd` relies on global variables
  USER=${user}
  PASS=${password}
  DB=${database}

  # need this to wait for the container to start up
  CONTAINER_IP=$(get_container_ip ${name})
  test_connection ${name}

  echo "  Testing login"

  assert_login_access ${user} ${password} true
  DB='admin' assert_login_access 'admin' ${admin_password} true

  echo "  Changing passwords"

  docker stop $(get_cid ${name})
  DOCKER_ARGS="
  -e MONGODB_DATABASE=${database}
  -e MONGODB_USER=${user}
  -e MONGODB_PASSWORD=NEW_${password}
  -e MONGODB_ADMIN_PASSWORD=NEW_${admin_password}
  -v ${volume_dir}:/var/lib/mongodb/data:Z
  "
  create_container "${name}_NEW" ${DOCKER_ARGS}

  # need to set this because `mongo_cmd` relies on global variables
  PASS="NEW_${password}"

  # need this to wait for the container to start up
  CONTAINER_IP=$(get_container_ip "${name}_NEW")
  test_connection "${name}_NEW"

  echo "  Testing login with new passwords"

  assert_login_access ${user} "NEW_${password}" true
  assert_login_access ${user} ${password} false

  DB='admin' assert_login_access 'admin' "NEW_${admin_password}" true
  DB='admin' assert_login_access 'admin' ${admin_password} false

  # need to remove volume_dir with sudo because of permissions of files written
  # by the Docker container
  sudo rm -rf ${volume_dir}

  echo "  Success!"
}

function run_mount_config_test() {
  echo "  Testing config file mount"
  local name="mount_config"
  local database='db'
  local user='user'
  local password='password'
  local admin_password='adminPassword'
  local volume_dir

  volume_dir=`mktemp -d --tmpdir mongodb-testdata.XXXXX`
  chmod a+rwx ${volume_dir}
  config_file=$volume_dir/mongod.conf

  echo "dbpath=/var/lib/mongodb/dbpath
  unixSocketPrefix = /var/lib/mongodb
  smallfiles = true
  noprealloc = true" > $config_file
  chmod a+r ${config_file}

  DOCKER_ARGS="
  -e MONGODB_DATABASE=${database}
  -e MONGODB_USER=${user}
  -e MONGODB_PASSWORD=${password}
  -e MONGODB_ADMIN_PASSWORD=${admin_password}
  -v ${config_file}:/etc/mongod.conf:Z
  -v ${volume_dir}:/var/lib/mongodb/dbpath:Z
  "

  create_container ${name} ${DOCKER_ARGS}

  # need to set these because `mongo_cmd` relies on global variables
  USER=${user}
  PASS=${password}
  DB=${database}

  # need this to wait for the container to start up
  CONTAINER_IP=$(get_container_ip ${name})
  echo "  Testing mongod is running"
  test_connection ${name}
  echo "  Testing config file works"
  docker exec $(get_cid ${name}) bash -c "test -S /var/lib/mongodb/mongodb-27017.sock"

  # need to remove volume_dir with sudo because of permissions of files written
  # by the Docker container
  sudo rm -rf ${volume_dir}

  echo "  Success!"
}

# # Tests baseline configuration
# run_configuration_tests
# USER="user1" PASS="pass1" DB="test_db" ADMIN_PASS="r00t" run_tests admin
#
# # Test random UID
# CONTAINER_ARGS="-u 12345" USER="user1" PASS="pass1" DB="test_db" ADMIN_PASS="r00t" run_tests admin_altuid
# run_change_password_test
# run_mount_config_test
