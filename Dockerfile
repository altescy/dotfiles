FROM homebrew/ubuntu18.04

ARG username="user"
ARG password="password"

# Install requirements
RUN apt-get update && \
    apt-get install -y build-essential curl file git locales locales-all zsh
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
