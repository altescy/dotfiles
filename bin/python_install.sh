#!/bin/bash

if (type "anyenv" > /dev/null 2>&1); then
    eval "$(anyenv init -)"
fi

if !(type "pyenv" > /dev/null 2>&1); then
    anyenv install pyenv
    eval "$(anyenv init -)"

    # Install latest conda
    PYTHON_VERSION="miniconda3-latest"
    pyenv install $PYTHON_VERSION
    pyenv rehash
    pyenv global $PYTHON_VERSION
    eval "$(anyenv init -)"

    # Upgrade conda & python
    conda update -y conda
    conda install -y python=3.8
fi

python --version
pip --version

pip install python-language-server pylint mypy yapf
