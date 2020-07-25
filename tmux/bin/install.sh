#!/bin/bash

if !(type "tmux" > /dev/null 2>&1); then
    if !(type "brew" > /dev/null 2>&1); then
        brew install tmux
    fi
fi

tmux -V
