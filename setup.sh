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
# then run as:
# curl -sSL https://github.com/pirafrank/dotfiles/raw/master/setup.sh | sudo -H -u YOURUSERNAME bash

if [[ $(uname -s) != 'Linux' ]]; then
  echo "Sorry, Linux only this time!"
  exit 1
fi

if [[ $EUID -eq 0 ]]; then
   echo "DO NOT run this script as root!"
   echo "And more... Have you created the user you want to run it from?"
   exit 1
fi

# explicitly moving to home dir
cd

# upgrade all the things
sudo apt-get update && sudo apt-get upgrade -y

# install locales
sudo apt-get install -y locales
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
LANGUAGE="en_US.UTF-8"

sudo apt-get install -y --no-install-recommends apt-utils \
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
  && sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com A1715D88E1DF1F24 \
  && sudo add-apt-repository ppa:git-core/ppa -y \
  && sudo apt-get update \
  && sudo apt-get install -y git \
  && echo "installing neovim" \
  && sudo apt-get install -y neovim

echo "make dirs" \
  && mkdir -p bin2 \
  && mkdir -p Code/Workspaces \
  && echo "clone and setup my dotfiles" \
  && git clone https://github.com/pirafrank/dotfiles.git Code/dotfiles \
  && ln -s $HOME/Code/dotfiles $HOME/dotfiles \
  && echo "config git global" \
  && /bin/bash dotfiles/git/git_config.sh \
  && echo "creating symlinks to dotfiles" \
  && ln -s dotfiles/bin bin \
  && ln -s dotfiles/git/.gitignore_global .gitignore_global \
  && ln -s dotfiles/tmux/.tmux.conf .tmux.conf \
  && ln -s dotfiles/vim/.vimrc .vimrc

echo "install zprezto" \
  && zsh dotfiles/setup_zprezto.zsh

echo "install tmux plugin manager" \
  && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
  && echo "install fzf" \
  && zsh setup_fzf.sh \
  && echo "change default shell" \
  && sudo chsh -s $(which zsh) $(whoami) \
  && echo "install lazygit" \
  && sudo add-apt-repository ppa:lazygit-team/release -y \
  && sudo apt-get update \
  && sudo apt-get install -y lazygit

# enter dotfiles repo root
cd dotfiles

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
  && sudo bash setup_docker_full.sh \
  && sudo usermod -aG docker $(whoami)

# install cloud clients
echo "install cloud clients" \
  && bash setup_cloud_clients.sh

# back home
cd
