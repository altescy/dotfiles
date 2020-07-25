.PHONY: all setup build_brew brew_install clean zsh_setup tmux_setup poetry_setup nvim_setup

PWD    := $(shell pwd)

all: clean env_setup config_setup

brew_setup:
	$(PWD)/bin/brew_setup.sh

app_setup:
	brew install anyenv neovim poetry tmux zsh

env_setup:
	$(PWD)/bin/anyenv_setup.sh
	$(PWD)/bin/nodenv_setup.sh
	$(PWD)/bin/pyenv_setup.sh

config_setup: zsh_setup tmux_setup editorconfig_setup poetry_setup nvim_setup

zsh_setup:
	$(PWD)/zsh/bin/setup.sh

tmux_setup:
	$(PWD)/tmux/bin/setup.sh

editorconfig_setup:
	$(PWD)/editorconfig/bin/setup.sh

poetry_setup:
	$(PWD)/poetry/bin/setup.sh

nvim_setup:
	$(PWD)/nvim/bin/setup.sh

clean:
	rm -rf $(HOME)/.zshrc
	rm -rf $(HOME)/.tmux.conf
	rm -rf $(HOME)/.editorconfig
	rm -rf $(HOME)/.config/nvim
