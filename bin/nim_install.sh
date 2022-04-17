#!/bin/bash

set -e

export CHOOSENIM_NO_ANALYTICS=1

if !(type "choosenim" > /dev/null 2>&1); then
    curl https://nim-lang.org/choosenim/init.sh -sSf | sh
    export PATH="$HOME/.nimble/bin:$PATH"
fi

choosenim stable
