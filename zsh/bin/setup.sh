yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f $HOME/.zshrc
ln -s `pwd`/zsh/conf.d/zshrc $HOME/.zshrc
cat `pwd`/zsh/conf.d/profile >> $HOME/.bash_profile
