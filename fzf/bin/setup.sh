#!/bin/bash

[ ! -d ~/.fzf ] && git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc
