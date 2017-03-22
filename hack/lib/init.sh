#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Returns the absolute path to the directory provided
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

init_source="$( dirname "${BASH_SOURCE}" )/../.."
OS_ROOT="$( absolute_path "${init_source}" )"
export OS_ROOT

library_files=( $( find "${OS_ROOT}/hack/lib" -type f -name '*.sh' -not -path '*/hack/lib/init.sh' ) )
library_files+=( "${OS_ROOT}/hack/common.sh" )
library_files+=( "${OS_ROOT}/hack/util.sh" )

for library_file in "${library_files[@]}"; do
	source "${library_file}"
done

unset library_files library_file init_source
