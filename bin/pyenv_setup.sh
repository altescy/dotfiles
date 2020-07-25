#!/bin/bash

anyenv install pyenv
exec $SHELL -l

# Install latest node
PYTHON_VERSION="miniconda3-latest"
pyenv install $PYTHON_VERSION
pyenv rehash
pyenv global $PYTHON_VERSION
exec $SHELL -l
