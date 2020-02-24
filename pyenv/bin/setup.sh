#!/bin/bash


### pyenv
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


### miniconda  - Install latest miniconda
VERSION=`pyenv install -l | grep miniconda | tail -n 1 | tr -d ' '`
pyenv install $VERSION
pyenv rehash
pyenv global $VERSION
conda update -y conda
