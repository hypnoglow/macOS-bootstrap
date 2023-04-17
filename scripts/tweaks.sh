#!/bin/bash
# WARNING! This file should not be executed directly.
# Shebang here is for shellcheck.
#
# Various system tweaks.
################################################################################

tweaks::hostname() {
    local target_hostname="$1"

    local current_hostname="$(scutil --get ComputerName)"
    if [[ "${current_hostname}" != "${target_hostname}" ]] ; then
        echo "Set ComputerName ..."
        echo "--> scutil --set ComputerName ${target_hostname}"
        scutil --set ComputerName ${target_hostname}
    fi

    local current_hostname="$(scutil --get LocalHostName)"
    if [[ "${current_hostname}" != "${target_hostname}" ]] ; then
        echo "Set LocalHostName ..."
        echo "--> scutil --set LocalHostName ${target_hostname}"
        scutil --set LocalHostName ${target_hostname}
    fi
}

tweaks::switch_to_zsh() {
    local zsh="$(command -v zsh)"

    if ! grep -q "${zsh}" /etc/shells; then
        echo "Adding ${zsh} to /etc/shells ..."
        echo "${zsh}" | sudo tee -a /etc/shells 1>/dev/null
    fi

    if [ "$(dscl . -read /Users/hypnoglow UserShell | cut -d ' ' -f 2)" != "${zsh}" ]; then
        echo "Changing shell to zsh ..."
        chsh -s "${zsh}"
    fi
}

tweaks::set_screenshots_dir() {
    local dirname="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Screenshots"

    if [ "$(defaults read com.apple.screencapture location)" = "${dirname}" ]; then
        return 0
    fi

    if [ ! -d "${dirname}" ]; then
        mkdir -p "${dirname}"
    fi

    echo "Setting default Screenshots location to iCloud ..."
    defaults write com.apple.screencapture location "${dirname}"
    killall SystemUIServer
}
