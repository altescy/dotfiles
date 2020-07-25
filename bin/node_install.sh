#!/bin/bash

if !(type "node" > /dev/null 2>&1); then
    if (type "anyenv" > /dev/null 2>&1); then
        eval "$(anyenv init -)"

        if !(type "nodenv" > /dev/null 2>&1); then
            anyenv install nodenv
            eval "$(anyenv init -)"
        fi

        # Install latest node
        if !(type "node" > /dev/null 2>&1); then
            NODE_VERSION=`nodenv install -l | grep -E '^[0-9]+\.[0-9]+\.[0-9]$' | tail -n 1`
            yes | nodenv install $NODE_VERSION
            nodenv rehash
            nodenv global $NODE_VERSION
            eval "$(anyenv init -)"
        fi
    fi
fi

node --version
npm --version
