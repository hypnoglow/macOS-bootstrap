#!/bin/bash
# WARNING! This file should not be executed directly.
# Shebang here is for shellcheck.
################################################################################

declare _ask__is_interactive=false

# $1 [bool] is interactive
ask::construct() {
    _ask__is_interactive=$1
}

# Asks user a question $1 and returns 0 if he answered 'y' or 1 otherwise.
ask::ask() {
    if [ -z "$1" ]; then
        echo "Internal error: ask::ask() called without a question." >&2
        exit 1
    fi

    local question="$1"
    local answer

    echo -n "$question [y/N]: "
    read -n 1 answer
    echo
    if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
        return 1
    fi

    return 0
}

# If called in non-interactive mode, always return true.
# Else return 0 or 1 based on answer.
ask::interactive() {
    if [ "${_ask__is_interactive}" = false ]; then
        return 0
    fi

    ask::ask "$1"
    return "$?"
}
