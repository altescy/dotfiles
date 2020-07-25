#!/bin/bash

if !(type "anyenv" > /dev/null 2>&1); then
    if (type "brew" > /dev/null 2>&1); then
        brew install anyenv
    fi
fi

yes | anyenv install --init
eval "$(anyenv init -)"
