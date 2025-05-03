#!/bin/bash

rm -rf $HOME/.config/nvim
mkdir -p $HOME/.config/nvim

ln -s `pwd`/nvim/conf.d/init.lua $HOME/.config/nvim/init.lua
ln -s `pwd`/nvim/conf.d/lua $HOME/.config/nvim/lua

nvim --headless -u $HOME/.config/nvim/init.lua +qall
