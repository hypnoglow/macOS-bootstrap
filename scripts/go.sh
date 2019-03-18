#!/bin/bash

go::get_packages() {
    if [ ! -x "$(which go 2>/dev/null)" ]; then
        echo "Go is not installed, skip installing go packages"
        return
    fi
    if [ -z "${GOPATH:-}" ]; then
        echo "GOPATH is not defined, skip installing go packages"
        return
    fi

    local packages=(
        github.com/msoap/go-carpet
        github.com/sqs/goreturns
        golang.org/x/tools/cmd/goimports
    )

    for package in "${packages[@]}"; do
        if [ -d "$GOPATH/src/${package}" ]; then
            continue
        fi

        echo "--> go get -u -v -t ${package}"
        go get -u -v -t ${package}
    done
}
