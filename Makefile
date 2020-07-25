.PHONY: all setup build_brew brew_install clean zsh_setup tmux_setup poetry_setup nvim_setup

PWD    := $(shell pwd)

all: clean env_setup app_setup

env_setup:
	$(PWD)/bin/brew_setup.sh
	brew install anyenv neovim poetry tmux zsh
	$(PWD)/bin/anyenv_setup.sh
	$(PWD)/bin/nodenv_setup.sh

app_setup: zsh_setup tmux_setup editorconfig_setup poetry_setup nvim_setup

clean:
	rm -rf $(HOME)/.zshrc
	rm -rf $(HOME)/.tmux.conf
	rm -rf $(HOME)/.editorconfig
	rm -rf $(HOME)/.config/nvim

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
