#!/bin/bash

apps::install_go_apps() {
    if [ ! -x "$(which go 2>/dev/null)" ]; then
        log::info "Go is not installed, skip installing go packages"
        return
    fi

    local packages=(
        github.com/msoap/go-carpet@v1.10.0
        github.com/daixiang0/gci@v0.13.5
        github.com/quasilyte/qbenchstat/cmd/qbenchstat@latest
    )

    local dir="${HOME}/go/bin"

    for package in "${packages[@]}"; do
        log::command "--> GOBIN=${dir} go install -v ${package}"
        GOBIN="${dir}" go install -v "${package}"
    done
}

apps::install_gh_extensions() {
    if [ ! -x "$(which gh 2>/dev/null)" ]; then
        log::info "gh is not installed, skip installing gh extensions"
        return
    fi

    log::command "gh extension install github/gh-copilot"
    gh extension install github/gh-copilot
}
