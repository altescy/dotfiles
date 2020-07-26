#!/bin/bash

if !(type "starship" > /dev/null 2>&1); then
    if (type "brew" > /dev/null 2>&1); then
        brew install starship
    else
        curl -fsSL https://starship.rs/install.sh | bash
    fi
fi

SOURCE_SCRIPT="source `pwd`/zsh/conf.d/zshrc"
! grep "${SOURCE_SCRIPT}" ~/.zshrc && echo "${SOURCE_SCRIPT}" >> ~/.zshrc

test -r ~/.bash_profile && cat `pwd`/zsh/conf.d/profile >> $HOME/.bash_profile
cat `pwd`/zsh/conf.d/profile >> $HOME/.profile
