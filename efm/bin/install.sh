#!/bin/bash

set -e

if !(type "efm-langserver" > /dev/null 2>&1); then
    if (type "brew" > /dev/null 2>&1); then
        brew install efm-langserver
    fi
fi
