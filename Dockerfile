FROM homebrew/ubuntu24.04

ARG username="user"
ARG password="password"

# Install requirements
RUN apt-get update && \
    apt-get install -y \
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
RUN locale-gen ja_JP.UTF-8 && update-locale
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /usr/local/src/*
RUN brew install tmux anyenv neovim

# Setup user
ENV USER  $username
ENV HOME /home/${USER}
ENV SHELL /usr/bin/zsh

# Create user
RUN useradd -m ${USER} && \
    gpasswd -a ${USER} sudo && \
    echo "${USER}:${password}" | chpasswd
RUN chown -R ${USER} /home/linuxbrew/.linuxbrew

# Install dotfiles
WORKDIR ${HOME}
COPY    ./ ./.dotfiles
RUN     chown -R ${USER} ${HOME}/.dotfiles
USER    ${USER}
RUN     cd .dotfiles && make

CMD ["/bin/zsh"]
