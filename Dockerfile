FROM ubuntu:20.04

# going headless
ENV DEBIAN_FRONTEND=noninteractive

ARG UBUNTURELEASE='focal'

# setting locales
RUN set -x \
  && apt-get clean && apt-get update \
  && apt-get install -y locales
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

# set debug mode and install dev and essentials packages
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends apt-utils \
  && apt-get install -y \
    build-essential \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    tzdata

# Set up timezone (tzdata required)
ENV TZ 'Europe/Rome'
RUN echo $TZ > /etc/timezone && \
  rm /etc/localtime && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata

# install dev software and dotfiles
# comments are more for Dockerfile maintenance
RUN set -x \
  && apt-get install -y \
    wget \
    vim \
    zsh \
    tmux \
    mosh \
    rsync \
    less \
    mc \
    tree \
    jq \
    postgresql-client \
    zlib1g-dev \
    unzip \
    zip \
    xz-utils \
    zutils \
    atop \
  && echo "getting newer git..." \
  && add-apt-repository ppa:git-core/ppa \
  && apt-get update \
  && apt-get install -y git \
  && echo "installing python3 (focal ships with 3.8)" \
  && apt-get install -y \
    python3-pip \
  && echo "installing neovim" \
  && apt-get install -y \
    neovim \
  && pip3 install neovim

# add user and change default shell
RUN set -x \
  && useradd -Um -d /home/work -G sudo -s /bin/bash work \
  && echo "change default shell" \
  && chsh -s $(which zsh) work

# install lazygit
RUN set -x \
  && echo "install lazygit" \
  && add-apt-repository ppa:lazygit-team/release \
  && apt-get update \
  && apt-get install lazygit

# install docker-cli (client only)
# RUN set -x \
#   && echo "install docker-cli (CLI client only)" \
#   && zsh setup_docker_cli.zsh $UBUNTURELEASE

USER work
WORKDIR /home/work

# copy setup scripts for different envs
COPY setup_zprezto.zsh \
  setup_fzf.sh \
  workspaces/setup_nvm.zsh \
  workspaces/setup_pyenv.zsh \
  workspaces/setup_rvm.zsh \
  workspaces/setup_rust.zsh \
  workspaces/setup_docker_cli.zsh \
  workspaces/setup_java.zsh \
  pre_start.zsh ./

# clone dotfiles and setup more dirs in HOME
RUN set -x \
  && echo "make dirs" \
  && mkdir -p bin2 \
  && mkdir -p Code/Workspaces \
  && echo "clone and setup my dotfiles" \
  && git clone https://github.com/pirafrank/dotfiles.git dotfiles \
  && echo "config git global" \
  && /bin/bash dotfiles/git/git_config.sh \
  && echo "creating symlinks to dotfiles" \
  && ln -s dotfiles/bin bin \
  && ln -s dotfiles/git/.gitignore_global .gitignore_global \
  && ln -s dotfiles/tmux/.tmux.conf .tmux.conf \
  && ln -s dotfiles/vim/.vimrc .vimrc

# zprezto has many submodules, going with a dedicated layer
RUN set -x \
  && echo "install zprezto" \
  && zsh setup_zprezto.zsh

# install tmux
RUN set -x \
  && echo "install tmux plugin manager" \
  && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
  && echo "install fzf" \
  && zsh setup_fzf.sh

# external mountpoints
VOLUME /home/work/Code
VOLUME /home/work/secrets
# Warning from the docs:
# If any build steps change the data within the volume
# AFTER it has been declared, those changes will be discarded.

# optional gitglobal config
# these are set at startup, if non-empty. you can set them with docker run
ENV GITUSERNAME=''
ENV GITUSEREMAIL=''

# set default terminal
ENV TERM=xterm-256color

CMD ["sh", "-c", "zsh pre_start.zsh ; zsh"]
