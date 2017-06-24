#!/bin/bash

go::get_packages() {
    local packages=(
        github.com/msoap/go-carpet
        github.com/golang/dep
        github.com/alecthomas/gometalinter
        github.com/sqs/goreturns
    )

    for package in "${packages[@]}"; do
        if [ -d "$GOPATH/src/${package}" ]; then
            continue
        fi

        echo "--> go get -u -v -t ${package}"
        go get -u -v -t ${package}
    done
}
