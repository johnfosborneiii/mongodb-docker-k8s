#!/bin/bash

function get_file_first_line_match() {
  egrep -m 1 ${2:-''} ${1:-''}
}
readonly -f get_file_first_line_match

function set_file_first_line_match_string_between_quotes() {
  sed -i "0,/${2:-''}/s|\(${2:-''}.*\"\).*\(\".*\)|\1${3:-''}\2| g" ${1:-''}
}
readonly -f set_file_first_line_match_string_between_quotes

function set_file_first_line_match_string_after_pattern() {
  sed -i "0,/${2:-''}/s|\(${2:-''}\).*|\1${3:-''}| g" ${1:-''}
}
readonly -f set_file_first_line_match_string_after_pattern
