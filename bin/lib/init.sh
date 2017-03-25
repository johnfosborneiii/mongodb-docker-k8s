#!/bin/bash

set -o errexit
set -o pipefail

# Returns directory absolute path
function absolute_path() {
	local relative_path="$1"
	local absolute_path

	pushd "${relative_path}" >/dev/null
	relative_path="$( pwd )"
	if [[ -h "${relative_path}" ]]; then
		absolute_path="$( readlink "${relative_path}" )"
	else
		absolute_path="${relative_path}"
	fi
	popd >/dev/null

	echo "${absolute_path}"
}
readonly -f absolute_path

function find_file() {
  local
	find . -not \( \
		\( \
		-wholename './_output' \
		-o -wholename './.*' \
		-o -wholename './pkg/assets/bindata.go' \
		-o -wholename './pkg/assets/*/bindata.go' \
		-o -wholename './pkg/bootstrap/bindata.go' \
		-o -wholename './openshift.local.*' \
		-o -wholename './test/extended/testdata/bindata.go' \
		-o -wholename '*/vendor/*' \
		-o -wholename './assets/bower_components/*' \
		\) -prune \
	\) -name '*.go' | sort -u
}
readonly -f find_file

# Global variables
OS_ROOT="$( absolute_path "$( dirname "${BASH_SOURCE}" )/../.." )"
BIN_DIRECTORY=${OS_ROOT}/bin
LIB_DIRECTORY=${BIN_DIRECTORY}/lib

# Set environment properties
export OS_ROOT

# Concatenate library files
library_files=( $( find "${LIB_DIRECTORY}" -type f -name '*.sh' -not -path "*${LIB_DIRECTORY}/init.sh" ) )

# Load libraries into current shell
for library_file in "${library_files[@]}"; do
	source "${library_file}"
done

# Remove library shell variables
unset library_files library_file
