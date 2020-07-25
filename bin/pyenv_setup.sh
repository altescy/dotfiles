#!/bin/bash

if !(type "pyenv" > /dev/null 2>&1); then
    anyenv install pyenv
    eval "$(anyenv init -)"
fi

# Install latest conda
PYTHON_VERSION="miniconda3-latest"
pyenv install $PYTHON_VERSION
pyenv rehash
pyenv global $PYTHON_VERSION
eval "$(anyenv init -)"
