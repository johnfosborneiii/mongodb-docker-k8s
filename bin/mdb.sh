#!/bin/bash

STARTTIME=$(date +%s)
OPTION=0
USAGE="Usage: [-b] [-r] [-t] imgDir"

source "$(dirname "${BASH_SOURCE}")/lib/init.sh"

while getopts "brth" opt ; do
  case $opt in
    b ) OPTION=1
    ;;
    r ) OPTION=2
    ;;
    t ) OPTION=3
    ;;
    h ) echo ${USAGE}
    exit 1
  esac
done

shift $(($OPTIND - 1))

if [ -z "$@" ]; then
  echo ${USAGE}
  exit 1
fi

case ${OPTION} in
  ${OPT_BLDC} ) echo "OPT_BLDC"
    ;;
  ${OPT_RUNC} ) echo "OPT_RUNC"
    ;;
  ${OPT_TEST} ) echo "OPT_TEST"
    ;;
esac

ret=$?; ENDTIME=$(date +%s); echo "$0 took $(($ENDTIME - $STARTTIME)) seconds"; exit "$ret"
