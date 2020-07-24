.PHONY: all setup build_brew brew_install clean zsh_setup tmux_setup fzf_setup nvim_setup

PWD    := $(shell pwd)

all: clean setup

setup: zsh_setup tmux_setup editorconfig_setup fzf_setup nvim_setup

build_brew:
	$(PWD)/brew/bin/build.sh

brew_install:
	brew install neovim tmux zsh

clean:
	rm -rf $(HOME)/.zshrc
	rm -rf $(HOME)/.tmux.conf
	rm -rf $(HOME)/.editorconfig
	rm -rf $(HOME)/.fzf
	rm -rf $(HOME)/.config/nvim

zsh_setup:
	$(PWD)/zsh/bin/setup.sh

tmux_setup:
	$(PWD)/tmux/bin/setup.sh

editorconfig_setup:
	$(PWD)/editorconfig/bin/setup.sh

fzf_setup:
	$(PWD)/fzf/bin/setup.sh

nvim_setup:
	$(PWD)/nvim/bin/setup.sh
