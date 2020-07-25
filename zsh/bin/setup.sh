#!/bin/bash

yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f $HOME/.zshrc
echo "source `pwd`/zsh/conf.d/zshrc" >> ~/.zshrc

test -r ~/.bash_profile && cat `pwd`/zsh/conf.d/profile >> $HOME/.bash_profile
cat `pwd`/zsh/conf.d/profile >> $HOME/.profile
