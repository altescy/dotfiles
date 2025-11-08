#!/bin/bash

reload() {
    if (type "anyenv" > /dev/null 2>&1); then
        eval "$(anyenv init -)"
    elif (type "pyenv" > /dev/null 2>&1); then
        eval "$(pyenv init -)"
    fi
}

reload

if !(type "pyenv" > /dev/null 2>&1); then
    if (type "anyenv" > /dev/null 2>&1); then
        anyenv install pyenv
        eval "$(anyenv init -)"
    fi
fi

if (type "pyenv" > /dev/null 2>&1); then
    # Install latest conda
    PYTHON_VERSION="3.13"
    pyenv install $PYTHON_VERSION
    pyenv rehash
    pyenv global $PYTHON_VERSION
    reload
fi

python --version
pip --version

pip install refurb
