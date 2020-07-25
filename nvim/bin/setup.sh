#!/bin/bash
rm -rf $HOME/.config/nvim $HOME/.config/coc $HOME/.cache/dein
mkdir -p $HOME/.config/nvim

ln -s `pwd`/nvim/conf.d/init.vim $HOME/.config/nvim/init.vim
ln -s `pwd`/nvim/conf.d/dein.toml $HOME/.config/nvim/dein.toml
ln -s `pwd`/nvim/conf.d/dein_lazy.toml $HOME/.config/nvim/dein_lazy.toml
ln -s `pwd`/nvim/conf.d/coc-settings.toml $HOME/.config/nvim/coc-settings.toml

nvim --headless -u $HOME/.config/nvim/init.vim +qall

# Install coc.nvim extensions
mkdir -p $HOME/.config/coc/extensions
cp `pwd`/nvim/conf.d/coc-package.json $HOME/.config/coc/extensions/package.json
pushd $HOME/.config/coc/extensions
npm install --no-package-lock
popd
