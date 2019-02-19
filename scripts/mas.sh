#!/bin/bash
# WARNING! This file should not be executed directly.
# Shebang here is for shellcheck.

mas::install_all() {
    echo "Check and install mas packages..."

    set -f # disable globbing because of special characters in packages file.
    local packages_file="$1"
    local line

    installed="$(mas list)"

    while IFS='' read -r line || [[ -n "${line}" ]]; do
        # Skip comments and empty lines
        if [[ "${line}" =~ ^# || -z "${line}" ]]; then
            continue
        fi

        # parse line
        local line_array=(${line})
        local app_id="${line_array[0]}"

        if mas::_need_to_install "${app_id}" "${installed}"; then
            mas::_install_one "${app_id}"
        fi
    done < "${packages_file}"
}

mas::_install_one() {
    local app_id="$1"

    echo "Installing ${app_id} ..."
    cmd="mas install ${app_id}"
    echo "--> ${cmd}"
    ${cmd}

    if [ $? -ne 0 ]; then
        echo "Failed to install ${app_id}" >&2
        exit 1
    fi
}

mas::_need_to_install() {
    local app_id="$1"
    local installed="$2"

    installed_apps="mas list"

    set +e
    pkg="$(echo "${installed}" | grep -e "^${app_id}\s")"
    set -e

    if [[ -n "${pkg}" ]] ; then
        echo "$pkg - already installed."
        return 1
    fi

    return 0
}