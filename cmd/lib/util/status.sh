#!/bin/bash

function get_status_code(){
  case "${1:-${OS_FAILURE}}" in
    ${OS_SUCCESS} ) echo "[SUCCESS] ${2:-${FUNCNAME[0]}}"
    ;;
    ${OS_FAILURE} ) echo "[FAILURE] ${2:-${FUNCNAME[0]}}"
    ;;
    ${OS_CHNAGED} ) echo "[CHNAGED] ${2:-${FUNCNAME[0]}}"
    ;;
    *) echo "[IGNORED] ${2:-${FUNCNAME[0]}}"
    ;;
  esac
}
readonly -f get_status_code
