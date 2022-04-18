#!/bin/bash

set -e

reload() {
    if (type "anyenv" > /dev/null 2>&1); then
        eval "$(anyenv init -)"
    elif (type "nodenv" > /dev/null 2>&1); then
        eval "$(nodenv init -)"
    fi
}

reload

if !(type "rbenv" > /dev/null 2>&1); then
    if (type "anyenv" > /dev/null 2>&1); then
        anyenv install rbenv
        eval "$(anyenv init -)"
    fi
fi

if (type "rbenv" > /dev/null 2>&1); then
    # Install latest node
    RUBY_VERSION=`rbenv install -l | grep -E '^[0-9]+\.[0-9]+\.[0-9]$' | tail -n 1`
    yes | rbenv install $RUBY_VERSION
    rbenv rehash
    rbenv global $RUBY_VERSION
    reload
fi

ruby --version
gem install solargraph
