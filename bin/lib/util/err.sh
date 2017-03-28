#!/bin/bash

function get_error_message(){
  case "${1:-${OS_FAILURE}}" in
    ${OS_SUCCESS} )
      echo -n "[SUCCESS] ${2:-${FUNCNAME[0]}}"
      ;;
    ${OS_FAILURE} )
      echo -n "[FAILURE] ${2:-${FUNCNAME[0]}}"
      ;;
    ${OS_CHNAGED} )
      echo -n "[CHNAGED] ${2:-${FUNCNAME[0]}}"
      ;;
    *)
      echo -n "[IGNORED] ${2:-${FUNCNAME[0]}}"
      ;;
  esac
}
readonly -f get_error_message
