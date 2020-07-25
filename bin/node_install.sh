#!/bin/bash

reload() {
    if (type "anyenv" > /dev/null 2>&1); then
        eval "$(anyenv init -)"
    elif (type "nodenv" > /dev/null 2>&1); then
        eval "$(nodenv init -)"
    fi
}

reload

if !(type "node" > /dev/null 2>&1); then
    if !(type "nodenv" > /dev/null 2>&1); then
        if (type "anyenv" > /dev/null 2>&1); then
            anyenv install nodenv
            eval "$(anyenv init -)"
        fi
    fi

    if (type "nodenv" > /dev/null 2>&1); then
        # Install latest node
        NODE_VERSION=`nodenv install -l | grep -E '^[0-9]+\.[0-9]+\.[0-9]$' | tail -n 1`
        yes | nodenv install $NODE_VERSION
        nodenv rehash
        nodenv global $NODE_VERSION
        reload
    fi
fi

node --version
npm --version
