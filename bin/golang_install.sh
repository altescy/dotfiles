#!/bin/bash

reload() {
    if (type "anyenv" > /dev/null 2>&1); then
        eval "$(anyenv init -)"
    elif (type "goenv" > /dev/null 2>&1); then
        eval "$(goenv init -)"
    fi
}

reload()

if !(type "go" > /dev/null 2>&1); then
    if (type "anyenv" > /dev/null 2>&1); then
        if !(type "goenv" > /dev/null 2>&1); then
            anyenv install goenv
            eval "$(anyenv init -)"
        fi
    fi

    if (type "goenv" > /dev/null 2>&1); then
        # Install latest golang
        GOLANG_VERSION=`goenv install -l | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]$' | tail -n 1`
        goenv install $GOLANG_VERSION
        goenv rehash
        goenv global $GOLANG_VERSION
        reload
    fi
fi

go version

go get -u golang.org/x/tools/cmd/gopls
go get golang.org/x/tools/cmd/goimports
