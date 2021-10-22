#!/bin/bash

#
# env
#

source workspace_versions.sh

#
# script
#

# NB: this script is meant to be run interactively.
# if needed, create your user first.

if [[ $(uname -s) != 'Linux' ]] || [[ ! -f /etc/debian_version ]]; then
  echo "Sorry, only Debian-based Linux distros are supported!"
  exit 1
fi

if [[ $EUID -eq 0 ]]; then
   echo "DO NOT run this script as root! Run as standard user with sudo power."
   echo "And more... Have you created the user you want to run it from?"
   exit 2
fi

# explicitly moving to home dir
cd

# base install
sudo bash base/setup_base.sh

echo "cleaning up" \
  && sudo apt-get autoremove -y && sudo apt-get clean -y

echo "change default shell" \
  && sudo chsh -s $(which zsh) $(whoami)

# clone repo
echo "cloning repository" \
  && git clone --recursive https://github.com/pirafrank/workspace.git ${HOME}/workspace

echo "install fzf" \
  && cd ${HOME}/workspace \
  && zsh base/setup_fzf.sh \
  && echo "install zprezto" \
  && zsh base/setup_zprezto.zsh

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

# install additonal utils
echo "install additional utilities" \
  && bash setups/setup_utils.sh

# install cloud clients
echo "install cloud clients" \
  && bash setups/setup_cloud_clients.sh
