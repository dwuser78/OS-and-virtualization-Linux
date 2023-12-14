#!/bin/bash
#
# The script deletes files of a certain type from a given directory

declare -ra FILE_TYPES=("tmp" "bak" "backup")

#######################################
# Outputs a log message with an error.
# Arguments:
#   Error description.
# Returns:
#   Log error message to STDERR.
#######################################
function err() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')]: $*" >&2
}

if [[ "$#" -le 0 ]]; then
    err "The directory is not specified"
    exit 1
fi

if ! [[ -d "$1" ]]; then
    err "The directory was not found"
    exit 1
fi

files=($1/*)

for file in ${files[@]}; do
    for type in ${FILE_TYPES[@]}; do
        if [[ "${file##*.}" == "${type}" ]]; then
            if [[ -w "${file}" ]]; then
                rm "${file}"
            else
                err "The file ${file} cannot be deleted"
            fi

            break
        fi
    done
done
