#!/bin/bash

#
# Install git
#

if !(type "git" > /dev/null 2>&1); then
    if (type "brew" > /dev/null 2>&1); then
        brew install git
    fi
fi

git --version

#
# Install hub
#

if !(type "hub" > /dev/null 2>&1); then
    if (type "brew" > /dev/null 2>&1); then
        brew install hub
    fi
fi

hub --version
