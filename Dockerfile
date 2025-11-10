FROM homebrew/ubuntu24.04

# Install requirements
RUN sudo apt-get update && \
    sudo apt-get install -y \
    build-essential \
    curl \
    wget \
    file \
    git \
    locales \
    locales-all \
    zsh \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl
RUN sudo apt-get autoremove -y && \
    sudo apt-get clean && \
    rm -rf /usr/local/src/*
RUN brew install tmux anyenv neovim hub

# Set up shell
ENV SHELL /usr/bin/zsh

# Install dotfiles
WORKDIR ${HOME}
COPY    ./ ./.dotfiles
RUN     cd .dotfiles && make

CMD ["/bin/zsh"]
