#!/bin/bash

#
# env
#

source workspace_versions.sh

#
# script
#

# notes:
# create your user first
# then run as:
# curl -sSL https://github.com/pirafrank/workspace/raw/main/setup.sh | sudo -H -u YOURUSERNAME bash

if [[ $(uname -s) != 'Linux' ]] || [[ ! -f /etc/debian_version ]]; then
  echo "Sorry, only Debian-based Linux distros are supported!"
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
    htop \
    bat \
    fd-find \
    python3 \
    python3-pip \
  && echo "getting newer git and clvv/fasd..." \
  && sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com A1715D88E1DF1F24 \
  && sudo add-apt-repository ppa:git-core/ppa -y \
  && sudo add-apt-repository ppa:aacebedo/fasd -y \
  && sudo apt-get update \
  && sudo apt-get install -y git fasd \
  && echo "change default shell" \
  && sudo chsh -s $(which zsh) $(whoami)

# clone repo
echo "cloning repository" \
  && git clone --recursive https://github.com/pirafrank/workspace.git ${HOME}/workspace

echo "install fzf" \
  && cd ${HOME}/workspace \
  && zsh setups/setup_fzf.sh \
  && echo "install zprezto" \
  && zsh setups/setup_zprezto.zsh

# dotfiles setup
echo "installing dotfiles" \
  && ln -s ${HOME}/workspace/dotfiles ${HOME}/dotfiles \
  && cd ${HOME}/dotfiles \
  && zsh install.sh all

# back to workspace dir
cd ${HOME}/workspace

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

# install java
echo "install Java $JAVAVERSION" \
  && zsh workspaces/setup_java.zsh $JAVAVERSION openjdk \
  && zsh workspaces/setup_mvn.sh

# install golang
echo "install Go" \
  && zsh workspaces/setup_golang.zsh

# install docker
echo "install docker" \
  && sudo bash setups/setup_docker_full.sh \
  && sudo usermod -aG docker $(whoami)

# install cloud clients
echo "install cloud clients" \
  && bash setups/setup_cloud_clients.sh

echo "install additional utilities" \
  && bash setups/setup_utils.sh

# back home
cd
