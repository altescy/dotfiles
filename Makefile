PWD    := $(shell pwd)
KERNEL := $(shell uname -s)
BREW   := $(shell which brew 2> /dev/null)


ifeq ($(KERNEL),Darwin)
	BREW_COMPILER := /usr/bin/ruby -e
	BREW_SOURCE := https://raw.githubusercontent.com/Homebrew/install/master/install
else
	BREW_COMPILER := sh -c
	BREW_SOURCE := https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh
endif

ifeq ($(BREW),)
	BREW_COMMAND := yes ' '| $(BREW_COMPILER) "$$(curl -fsSL $(BREW_SOURCE))"
endif


.PHONY: all setup build_brew brew_bundle clean zsh_setup tmux_setup pyenv_setup nvim_setup

all: clean setup
setup: zsh_setup tmux_setup pyenv_setup nvim_setup

build_brew:
	$(BREW_COMMAND)
	$(PWD)/brew/bin/setup.sh
brew_bundle:
	brew install neovim tmux zsh

clean:
	rm -rf $(HOME)/.zshrc
	rm -rf $(HOME)/.tmux.conf
	rm -rf $(HOME)/.pyenv
	rm -rf $(HOME)/.config/nvim

zsh_setup:
	$(PWD)/zsh/bin/setup.sh

tmux_setup:
	$(PWD)/tmux/bin/setup.sh

pyenv_setup:
	$(PWD)/pyenv/bin/setup.sh

nvim_setup:
	$(PWD)/nvim/bin/setup.sh
