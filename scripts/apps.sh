#!/bin/bash
# WARNING! This file should not be executed directly.
# Shebang here is for shellcheck.
#
################################################################################

apps::nodejs-n() {
    if [ -x "$(which n 2> /dev/null)" ]; then
        return 0
    fi

    if ! ask::interactive "Install node.js-n?"; then
        return 0
    fi

    echo "Installing node.js-n ..."
    git clone https://github.com/tj/n ${HOME}/sources/tj/n
    cd ${HOME}/sources/tj/n
    PREFIX=${HOME}/apps/n make install

    # Install latest node
    echo "Installing latest Node.js ..."
    export N_PREFIX="${HOME}/apps/n"
    export PATH="$PATH:$N_PREFIX/bin"
    n latest
}
