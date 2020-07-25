#!/bin/bash

if !(type "nvim" > /dev/null 2>&1); then
    if (type "brew" > /dev/null 2>&1); then
        brew instal neovim
    fi
fi

nvim --version
