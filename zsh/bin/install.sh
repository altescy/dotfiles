#!/bin/bash

if !(type "zsh" > /dev/null 2>&1); then
    if !(type "brew" > /dev/null 2>&1); then
        brew install zsh
    fi
fi

zsh --version
