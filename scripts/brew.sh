# shellcheck shell=ksh
#
# Package management using Homebrew.
################################################################################

declare -g -A _installed

brew::reconcile() {
    echo "Check and install brew packages..."

    local packages_file="$1"
    local line

    if [[ ! -r "${packages_file}" ]]; then
        echo "File ${packages_file} does not exist" >&2
        return 1
    fi

    _installed["core"]="$(brew list -1)"
    _installed["cask"]="$(brew cask list -1)"

    set -f # disable globbing because of special characters in packages file.
    while IFS='' read -r line || [[ -n "${line}" ]]; do
        # Skip comments and empty lines
        if [[ "${line}" =~ ^# || -z "${line}" ]]; then
            continue
        fi

        # parse line
        local line_array=(${line})
        local package_name="${line_array[0]}"
        local tap=""
        if [[ "${line_array[1]-}" = "|" ]]; then
            tap="${line_array[2]}"
        fi

        if brew::_need_to_install "${package_name}" "${tap}" ; then
            brew::_install_one "${package_name}" "${tap}"
        fi
    done < "${packages_file}"
}

brew::install_homebrew() {
    if ! which brew 1>/dev/null ; then
        echo "Install Homebrew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    taps=(
        homebrew/cask
        homebrew/cask-versions
        homebrew/cask-fonts
    )
    taps_installed="$(HOMEBREW_NO_AUTO_UPDATE=1 brew tap)"
    for tap in "${taps[@]}"; do
        if ! echo "${taps_installed}" | grep -q "${tap}"; then
            echo "--> brew tap "${tap}""
            brew tap "${tap}"
        fi
    done
}

brew::update() {
    echo "--> brew update"
    brew update
}

brew::upgrade_core() {
    echo "--> brew outdated"
    outdated=$(brew outdated --verbose)
    echo -e "$outdated"
    if [ -n "$outdated" ] && ask::interactive "Run brew upgrade?"; then
        echo "--> brew upgrade --ignore-pinned"
        brew upgrade --ignore-pinned
        # echo "--> brew cleanup --prune=300"
        # brew cleanup --prune=300
    fi
}

brew::upgrade_cask() {
    echo "--> brew cask outdated"
    outdated=$(brew::_cask_outdated "$1" --verbose)
    echo -e "$outdated"
    if [ -n "$outdated" ] && ask::interactive "Run brew cask reinstall \$(brew cask outdated)?"; then
        echo "--> brew cask reinstall \$(brew cask outdated)"
        brew::_cask_outdated "$1" | xargs brew cask reinstall
        # brew cask cleanup
    fi
}

brew::_cask_outdated() {
    local pins_file="${1:-}"
    local args="${2:-}"
    local line

    if [[ -z "${pins_file}" ]]; then
        brew cask outdated ${args}
        return 0
    fi

    if [[ ! -r "${pins_file}" ]]; then
        echo "File ${pins_file} does not exist" >&2
        return 1
    fi

    outdated=$(brew cask outdated ${args})

    while IFS='' read -r line || [[ -n "${line}" ]]; do
        # Skip comments and empty lines
        if [[ "${line}" =~ ^# || -z "${line}" ]]; then
            continue
        fi

        local package_name="${line}"
        outdated=$(echo -e "${outdated}" | grep -v -e "^${package_name}")
    done < "${pins_file}"

    echo -e "${outdated}"
}

brew::_install_one() {
    local package_name="$1"
    local tap="$2"

    echo "Install '${package_name}' ..."
    cmd="brew ${tap} install ${package_name}"
    echo "--> ${cmd}"
    ${cmd}

    if [ $? -ne 0 ]; then
        echo "Failed to install '${package_name}'" >&2
        exit 1
    fi
}

brew::_need_to_install() {
    local package_name="$1"
    local tap="$2"

    # If we have prepared list of installed packages for this tap (or core),
    # then we can check very fast.

    tap_key="${tap:-core}"
    if [[ ${_installed[$tap_key]+_} ]]; then
        if echo "${_installed[$tap_key]}" | grep -q -e "^${package_name}$" ; then
            echo "Skip package '${package_name}' - already installed."
            return 1
        fi
        return 0
    fi

    # Fallback to slow check.

    if brew ${tap} list "${package_name}" &>/dev/null ; then
        echo "Skip package '${package_name}': already installed."
        return 1
    fi

    return 0
}
