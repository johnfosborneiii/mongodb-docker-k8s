#!/bin/bash

# Provides simple utility functions

# pushd quiet directory stack
function pushd() {
  command pushd "$@" > /dev/null
}

# popd quiet directory stack
function popd() {
  command popd "$@" > /dev/null
}

# kill_all_processes kills processes currently executing jobs
function kill_all_processes() {
	local sudo="${USE_SUDO:+sudo}"

	pids=($(jobs -pr))
	for i in ${pids[@]-}; do
		pgrep -P "${i}" | xargs $sudo kill &> /dev/null
		$sudo kill ${i} &> /dev/null
	done
}
readonly -f kill_all_processes

# truncate_large_logs truncates large logs
function truncate_large_logs() {
	local max_file_size="100M"
	local large_files=$(find "${ARTIFACT_DIR}" "${LOG_DIR}" -type f -name '*.log' \( -size +${max_file_size} \))

	for file in ${large_files}; do
		mv "${file}" "${file}.tmp"
		echo "LOGFILE TOO LONG ($(du -h "${file}.tmp")), PREVIOUS BYTES TRUNCATED. LAST ${max_file_size} OF LOGFILE:" > "${file}"
		tail -c ${max_file_size} "${file}.tmp" >> "${file}"
		rm "${file}.tmp"
	done
}
readonly -f truncate_large_logs

function get_file_first_line_match() {
  egrep -m 1 ${2:-''} ${1:-''}
}
readonly -f get_file_first_line_match

function get_string_between_quotes() {
  expr "${1:-''}" : '.*\"\(.*\)\".*'
}
readonly -f get_string_between_quotes

function set_file_first_line_match_string_between_quotes() {
  sed -i "0,/${2:-''}/s|\(${2:-''}.*\"\).*\(\".*\)|\1${3:-''}\2| g" ${1:-''}
}
readonly -f get_string_between_quotes

function set_file_first_line_match_string_after_pattern() {
  sed -i "0,/${2:-''}/s|\(${2:-''}\).*|\1${3:-''}| g" ${1:-''}
}
