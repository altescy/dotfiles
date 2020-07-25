#!/bin/bash

anyenv install pyenv
eval "$(anyenv init -)"

# Install latest conda
PYTHON_VERSION="miniconda3-latest"
pyenv install $PYTHON_VERSION
pyenv rehash
pyenv global $PYTHON_VERSION
eval "$(anyenv init -)"
