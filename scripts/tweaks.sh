#!/bin/bash
# WARNING! This file should not be executed directly.
# Shebang here is for shellcheck.
#
# Various system tweaks.
################################################################################

tweaks::switch_to_zsh() {
    local zsh="/usr/local/bin/zsh"

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

tweaks::hostname() {
    local hostname="$1"
    if [[ "$(hostname -s)" != "${hostname}" ]] ; then
        echo "--> Set hostname \"${hostname}\""
        sudo hostname ${hostname}
    fi
}
