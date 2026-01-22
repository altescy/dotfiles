#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Setting up Ghostty for macOS"
    rm -f $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
    mkdir -p $HOME/Library/Application\ Support/com.mitchellh.ghostty
    ln -s `pwd`/ghostty/conf.d/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
elif [ "$XDG_CONFIG_HOME" != "" ]; then
    echo "Setting up Ghostty for XDG_CONFIG_HOME at $XDG_CONFIG_HOME"
    rm -f $XDG_CONFIG_HOME/ghostty/config
    mkdir -p $XDG_CONFIG_HOME/ghostty
    ln -s `pwd`/ghostty/conf.d/tmux.conf $XDG_CONFIG_HOME/ghostty/config
else
    echo "Setting up Ghostty for default XDG config at $HOME/.config"
    rm -f $HOME/.config/ghostty/config
    mkdir -p $HOME/.config/ghostty
    ln -s `pwd`/ghostty/conf.d/config $HOME/.config
fi
