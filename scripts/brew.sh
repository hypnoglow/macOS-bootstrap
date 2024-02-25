# shellcheck shell=ksh
#
# Package management using Homebrew.
################################################################################

declare -g -a _installed

brew::reconcile() {
    log::info "Check and install brew packages..."

    local packages_file="$1"
    local line

    if [[ ! -r "${packages_file}" ]]; then
        log::error "File ${packages_file} does not exist" >&2
        return 1
    fi

    _installed="$(brew list --full-name -1)"

    local -a packages

    set -f # disable globbing because of special characters in packages file.
    while IFS='' read -r line || [[ -n "${line}" ]]; do
        # Skip comments and empty lines
        if [[ "${line}" =~ ^# || -z "${line}" ]]; then
            continue
        fi

        # parse line
        local line_array=(${line})
        local package_name="${line_array[0]}"

        packages+=(${package_name})
    done < "${packages_file}"

    for package_name in "${packages[@]}"
    do
        if brew::_need_to_install "${package_name}" ; then
            brew::_install_one "${package_name}"
        fi
    done
}

brew::install_homebrew() {
    if ! which brew 1>/dev/null ; then
        log::info "Install Homebrew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # TODO: do we still need it? We now install packages using fully-qualified
    # name, so, probably, we don't need it.
    taps=(
        homebrew/cask
        homebrew/cask-versions
        homebrew/cask-fonts
    )
    taps_installed="$(HOMEBREW_NO_AUTO_UPDATE=1 brew tap)"
    for tap in "${taps[@]}"; do
        if ! echo "${taps_installed}" | grep -q "${tap}"; then
            log::command "--> brew tap "${tap}""
            brew tap "${tap}"
        fi
    done
}

brew::update() {
    log::command "--> brew update"
    brew update
}

brew::upgrade_core() {
    log::command "--> brew outdated --formulae"
    outdated=$(brew outdated --formulae --verbose)
    echo -e "$outdated"
    if [ -n "$outdated" ] && ask::interactive "Run 'brew upgrade'?"; then
        log::command "--> brew upgrade --formulae"
        brew upgrade --formulae
        # echo "--> brew cleanup --prune=300"
        # brew cleanup --prune=300
    fi
}

brew::upgrade_cask() {
    log::command "--> brew outdated --cask"
    outdated=$(brew::_cask_outdated "$1" --verbose)
    echo -e "$outdated"
    if [ -n "$outdated" ] && ask::interactive "Run 'brew upgrade'?"; then
        log::command "--> brew upgrade --cask \$(brew outdated --cask)"
        brew::_cask_outdated "$1" | xargs brew upgrade --cask
        # brew cask cleanup
    fi
}

brew::_cask_outdated() {
    local pins_file="${1:-}"
    local args="${2:-}"
    local line

    if [[ -z "${pins_file}" ]]; then
        brew outdated --cask ${args}
        return 0
    fi

    if [[ ! -r "${pins_file}" ]]; then
        log::error "File ${pins_file} does not exist" >&2
        return 1
    fi

    outdated=$(brew outdated --cask ${args})

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

    log::info "Install '${package_name}' ..."
    log::command "--> brew install ${package_name}"
    brew install "${package_name}"

    if [ $? -ne 0 ]; then
        log::error "Failed to install '${package_name}'" >&2
        exit 1
    fi
}

brew::_need_to_install() {
    local package_name="$1"

    # If we have prepared list of installed packages,
    # then we can check very fast.

    if echo "${_installed}" | grep -q -e "^${package_name}$" ; then
        log::debug "Skip package '${package_name}' - already installed (fast check)."
        return 1
    fi

    # Fallback to slow check.

    if brew list "${package_name}" &>/dev/null ; then
        log::debug "Skip package '${package_name}' - already installed (slow check)."
        return 1
    fi

    return 0
}
