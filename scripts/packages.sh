#!/bin/bash
# WARNING! This file should not be executed directly.
# Shebang here is for shellcheck.
#
# Installs packages.
################################################################################

packages::install() {
    echo "Check and install packages..."

    set -f # disable globbing because of special characters in packages file.
    local packages_file="$1"
    local line

    while IFS='' read -r line || [[ -n "${line}" ]]; do
        # Skip comments and empty lines
        if [[ "${line}" =~ ^# || -z "${line}" ]]; then
            continue
        fi

        # parse line
        local line_array=(${line})
        local package_name
        local cask=""
        if [ -z "${line_array[1]-}" ]; then
            package_name="${line_array[0]-}"
        elif [ "${line_array[0]}" = "%" ]; then
            package_name="${line_array[1]}"
            cask="cask"
        else
            echo "Bad config format on line:"
            echo "${line}"
            exit 1
        fi

        if packages::_need_to_install "${package_name}" "${cask}"; then
            packages::_install_one "${package_name}" "${cask}"
        fi
    done < "${packages_file}"
}

packages::_install_one() {
    local pakage_name="$1"
    local cask="$2"

    echo "Install '${package_name}' ..."
    cmd="brew ${cask} install "${package_name}""
    echo "--> ${cmd}"
    ${cmd}

    if [ $? -ne 0 ]; then
        echo "Failed to install '${package_name}'" >&2
        exit 1
    fi
}

packages::_need_to_install() {
    local package_name="$1"
    local cask="$2"

    if brew ${cask} list "${package_name}" &>/dev/null ; then
        echo "Skip package '${package_name}': already installed."
        return 1
    fi

    return 0
}
