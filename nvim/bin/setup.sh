rm -rf $HOME/.config/nvim
mkdir -p $HOME/.config/nvim

ln -s `pwd`/nvim/conf.d/init.vim $HOME/.config/nvim/init.vim
ln -s `pwd`/nvim/conf.d/dein.toml $HOME/.config/nvim/dein.toml
ln -s `pwd`/nvim/conf.d/dein_lazy.toml $HOME/.config/nvim/dein_lazy.toml

pip install -U neovim

nvim -u $HOME/.config/nvim/init.vim
