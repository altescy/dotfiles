#!/bin/bash

if !(type "anyenv" > /dev/null 2>&1); then
    if (type "brew" > /dev/null 2>&1); then
        brew install anyenv
    else
        git clone https://github.com/anyenv/anyenv ~/.anyenv
        export PATH="$HOME/.anyenv/bin:$PATH"
        echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.zshrc
    fi
fi

yes | anyenv install --init
eval "$(anyenv init -)"
