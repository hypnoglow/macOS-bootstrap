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
