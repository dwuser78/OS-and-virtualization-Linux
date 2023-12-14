#!/bin/bash
#
# The script that copies files from a specific directory to directories named
# after the owner of each file.

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
    if ! [[ -r "${file}" ]]; then
        err "The file ${file} cannot be copied"
    else
        user=$(stat -c %U "${file}")
        group=$(stat -c %G "${file}")

        if ! [[ -d "$1/${user}" ]]; then
            mkdir "$1/${user}"

            # If there are rights, restore the owner of the target directory
            if [[ "${USER}" == "root" ]]; then
                chown "${user}:${group}" "$1/${user}"
            fi
        fi

        cp "${file}" "$1/${user}/"

        # If there are rights, restore the owner of the copied file
        if [[ "${USER}" == "root" ]]; then
            chown "${user}:${group}" "$1/${user}/$(basename "${file}")"
        fi
    fi
done
