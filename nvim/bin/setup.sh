#!/bin/bash

rm -rf $HOME/.config/nvim $HOME/.config/coc $HOME/.cache/dein
mkdir -p $HOME/.config/nvim

ln -s `pwd`/nvim/conf.d/init.lua $HOME/.config/nvim/init.lua
ln -s `pwd`/nvim/conf.d/lua $HOME/.config/nvim/lua
ln -s `pwd`/nvim/conf.d/coc-settings.json $HOME/.config/nvim/coc-settings.json

nvim --headless -u $HOME/.config/nvim/init.lua +qall

# Install coc.nvim extensions
if (type "anyenv" > /dev/null 2>&1); then
    eval "$(anyenv init -)"
fi
mkdir -p $HOME/.config/coc/extensions
cp `pwd`/nvim/conf.d/coc-package.json $HOME/.config/coc/extensions/package.json
cd $HOME/.config/coc/extensions
npm install --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
