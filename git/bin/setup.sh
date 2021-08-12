#!/bin/bash

cp git/conf.d/gitconfig ~/.gitconfig

cp git/conf.d/gitignore_global ~/.gitignore_global
git config --global core.excludesFile '~/.gitignore_global'
