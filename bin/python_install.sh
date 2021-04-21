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
    PYTHON_VERSION="miniconda3-latest"
    pyenv install $PYTHON_VERSION
    pyenv rehash
    pyenv global $PYTHON_VERSION
    reload

    # Upgrade conda & python
    conda update -y conda
    conda install -y python=3.8
fi

python --version
pip --version

pip install python-language-server flake8 mypy black isort
