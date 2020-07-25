PWD                   = $(shell pwd)
DOCKER                = docker
DOCKER_USERNAME       = user
DOCKER_PASSWORD       = password
DOCKER_IMAGE_NAME     = dotfiles
DOCKER_CONTAINER_NAME = dotfiles
DOCKERFILE_PATH       = $(PWD)/docker/Dockerfile

.PHONY: all brew \
        apps anyenv_app fzf_app nvim_app poetry_app tmux_app zsh_app \
	    languages clang golang node python rust \
	    configs editorconfig nvim poetry tmux zsh \
	    docker docker_attach docker_build docker_run docker_stop \
	    clean editorconfig_clean nvim_clean tmux_clean zsh_clean

all: clean apps configs

brew:
	$(PWD)/bin/brew_install.sh

#
#  APPS
#

apps: anyenv_app fzf_app nvim_app tmux_app zsh_app

anyenv_app:
	$(PWD)/bin/anyenv_install.sh

fzf_app:
	$(PWD)/bin/fzf_install.sh

nvim_app:
	$(PWD)/nvim/bin/install.sh

poetry_app: python
	$(PWD)/poetry/bin/install.sh

tmux_app:
	$(PWD)/tmux/bin/install.sh

zsh_app:
	$(PWD)/zsh/bin/install.sh

#
#  LANGUAGES
#

languages: clang golang node python rust

clang:
	$(PWD)/bin/clang_install.sh

golang:
	$(PWD)/bin/golang_install.sh

node:
	$(PWD)/bin/node_install.sh

python:
	$(PWD)/bin/python_install.sh

rust:
	$(PWD)/bin/rust_install.sh

#
#  CONFIGS
#

configs: editorconfig nvim poetry tmux zsh

editorconfig:
	$(PWD)/editorconfig/bin/setup.sh

nvim: node nvim_app
	$(PWD)/nvim/bin/setup.sh

poetry: poetry_app
	$(PWD)/poetry/bin/setup.sh

tmux: tmux_app
	$(PWD)/tmux/bin/setup.sh

zsh: zsh_app
	$(PWD)/zsh/bin/setup.sh

#
#  DOCKER
#
docker: docker_build docker_run

docker_build:
	$(DOCKER) build -t $(DOCKER_IMAGE_NAME) -f $(DOCKERFILE_PATH) $(PWD) \
		--build-arg username=$(DOCKER_USERNAME) --build-arg password=$(DOCKER_PASSWORD)

docker_run: docker_build
	$(DOCKER) run -it --name $(DOCKER_CONTAINER_NAME) $(DOCKER_IMAGE_NAME)

docker_attach:
	$(DOCKER) attach $(DOCKER_CONTAINER_NAME)

docker_stop:
	$(DOCKER) stop $(DOCKER_CONTAINER_NAME)

docker_rm: docker_stop
	$(DOCKER) rm $(DOCKER_CONTAINER_NAME)

#
#  CLEAN
#

clean: editorconfig_clean nvim_clean tmux_clean zsh_clean

editorconfig_clean:
	rm -rf $(HOME)/.editorconfig

nvim_clean:
	rm -rf $(HOME)/.config/nvim
	rm -rf $(HOME)/.config/coc
	rm -rf $(HOME)/.cache/dein

tmux_clean:
	rm -rf $(HOME)/.tmux.conf

zsh_clean:
	rm -rf $(HOME)/.zshrc
