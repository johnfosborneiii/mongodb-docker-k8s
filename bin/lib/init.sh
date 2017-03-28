#!/bin/bash

# This script is the entrypoint for Bash scripts to import all of the support libraries.

set -o errexit
set -o pipefail

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

OS_ROOT="$( absolute_path "$( dirname "${BASH_SOURCE}" )/../.." )"
readonly OS_LIB_PATH="${OS_ROOT}/bin/lib"
export OS_ROOT

# Concatenate library files
library_files=( $( find "${OS_LIB_PATH}" -type f -name '*.sh' -not -path "*${OS_LIB_PATH}/init.sh" ) )

# Load libraries into current shell
for library_file in "${library_files[@]}"; do
	source "${library_file}"
done

unset library_files library_file

# Load version information
get_version_vars
