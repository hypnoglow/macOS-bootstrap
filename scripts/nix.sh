# shellcheck shell=bash
#
# Package management using Nix.
# See: https://nixos.org/nix/manual

nix::install_nix() {
    if which nix 1>/dev/null ; then
        return 0
    fi

    echi "Install Nix..."
    sh <(curl https://nixos.org/nix/install)
}
