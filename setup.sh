#!/bin/bash

#
# env
#

NODEVERSION=12
RUBYVERSION='2.6'
PYTHON3VERSION='3.7.7'

#
# script
#

# notes:
# create your user first
# DO NOT run this script as sudo

if [[ $(uname -s) != 'Linux' ]]; then
  echo "Sorry, Linux only this time!"
  exit 1
fi

sudo apt-get update && sudo apt-get install -y locales
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
LANGUAGE="en_US.UTF-8"

sudo apt-get update \
  && sudo apt-get install -y --no-install-recommends apt-utils \
  && sudo apt-get install -y \
    build-essential \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    tzdata

TZ='Europe/Rome'
echo $TZ | sudo tee /etc/timezone && \
  sudo rm /etc/localtime && \
  sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  sudo dpkg-reconfigure -f noninteractive tzdata

sudo apt-get install -y \
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
  && echo "getting newer git..." \
  && sudo add-apt-repository ppa:git-core/ppa \
  && sudo apt-get update \
  && sudo apt-get install -y git \
  && echo "installing neovim" \
  && sudo apt-get install -y neovim

echo "make dirs" \
  && mkdir bin2 \
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

echo "install zprezto" \
  && zsh setup_zprezto.zsh

echo "install tmux plugin manager" \
  && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
  && echo "install fzf" \
  && git clone --depth 1 https://github.com/junegunn/fzf.git .fzf \
  && cp -a dotfiles/fzf/.fzf* ./ \
  && echo "change default shell" \
  && chsh -s $(which zsh) \
  && echo "install lazygit" \
  && add-apt-repository ppa:lazygit-team/release \
  && apt-get update \
  && apt-get install lazygit

# install pyenv and python
echo "install pyenv and python" \
  && zsh workspaces/setup_pyenv.zsh $PYTHON3VERSION

# install nvm and node
echo "install nvm and node" \
  && zsh workspaces/setup_nvm.zsh $NODEVERSION

# install rvm and jekyll
echo "install rvm and ruby" \
  && zsh workspaces/setup_rvm.zsh $RUBYVERSION

# install rust and cargo
echo "install rust and cargo" \
  && zsh workspaces/setup_rust.zsh

# install docker
echo "install docker" \
  && bash setup_docker_full.sh


