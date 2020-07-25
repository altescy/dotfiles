#!/bin/bash
if (type "anyenv" > /dev/null 2>&1); then
    eval "$(anyenv init -)"
fi

if !(type "poetry" > /dev/null 2>&1); then
    pip install poetry
fi
