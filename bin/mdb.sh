#!/bin/bash

STARTTIME=$(date +%s)
source "$(dirname "${BASH_SOURCE}")/lib/init.sh"

usage="Usage: [-b imgDir] [-r imgDir] [-t imgDir]"

while getopts "brth" opt ; do
  case $opt in
    b ) create ${OPTARG}
    ;;
    r ) docker_run_container ${OPTARG}
    ;;
    t ) echo "TBD (test)"
    ;;
    h ) echo ${usage}
    exit 1
  esac
done

shift $(($OPTIND - 1))

if [ -z "$@" ]; then
  echo $usage
  exit 1
fi

ret=$?; ENDTIME=$(date +%s); echo "$0 took $(($ENDTIME - $STARTTIME)) seconds"; exit "$ret"
