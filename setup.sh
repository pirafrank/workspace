#!/bin/bash

#
# env
#

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

#
# script
#

# NB: this script is meant to be run interactively.
# if needed, create your user first.

# pre-run checks start

if [[ $(uname -s) != 'Linux' ]] || [[ ! -f /etc/debian_version ]]; then
  echo "Sorry, only Debian-based Linux distros are supported!"
  exit 1
fi

if [[ $EUID -eq 0 ]]; then
   echo "DO NOT run this script as root! Run as standard user with sudo power."
   echo "And more... Have you created the user you want to run it from?"
   exit 2
fi

# pre-run checks end

echo "
*************************
    setup.sh starting
*************************
"

echo "
cat workspace_versions.sh
-------------------------
" && \
  cat workspace_versions.sh && \
  source workspace_versions.sh

# explicitly moving to home dir
cd

# base install
sudo bash "$SCRIPT_DIR/base/setup_base.sh"

echo "cleaning up" \
  && sudo apt-get autoremove -y && sudo apt-get clean -y

echo "change default shell" \
  && sudo usermod -s $(which zsh) $(whoami)

if [ "$1" = "--skip-clone" ]; then
  # skip it
  echo "Skipping repo cloning"
  WORKSPACE_DIR=${SCRIPT_DIR}
else
  # clone repo
  echo "cloning repository"
  git clone --recursive https://github.com/pirafrank/workspace.git ${HOME}/workspace
  WORKSPACE_DIR="${HOME}/workspace"
fi

echo "install fzf" \
  && cd ${WORKSPACE_DIR} \
  && zsh base/setup_fzf.sh \
  && echo "install zprezto" \
  && zsh base/setup_zprezto.zsh

# dotfiles setup
echo "installing dotfiles" \
  && ln -s ${WORKSPACE_DIR}/dotfiles ${HOME}/dotfiles \
  && cd ${WORKSPACE_DIR}/dotfiles \
  && zsh install.sh all

# install deps to compile python shims and rubies
echo "installing dependencies to compile python shims and rubies" \
  && sudo apt-get install -y \
    autoconf \
    automake \
    bison \
    build-essential \
    curl \
    gawk \
    git \
    libbz2-dev \
    libffi-dev \
    libgdbm-dev \
    libgmp-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libyaml-dev \
    llvm \
    pkg-config \
    python-openssl \
    sqlite3 \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev \
  && sudo apt-get autoremove -y && sudo apt-get clean -y

# back to workspace dir
cd ${WORKSPACE_DIR}

# install pyenv and python
echo "install pyenv and python" \
  && zsh workspaces/setup_pyenv.sh $PYTHON3VERSION

# install nvm and node
echo "install nvm and node" \
  && zsh workspaces/setup_nvm.sh $NODEVERSION

# install rvm and jekyll
echo "install rvm and ruby" \
  && zsh workspaces/setup_rvm.sh $RUBYVERSION

# install rust and cargo
echo "install rust and cargo" \
  && zsh workspaces/setup_rust.sh

# install java
echo "install Java $JAVAVERSION" \
  && zsh workspaces/setup_java.sh $JAVAVERSION openjdk \
  && zsh workspaces/setup_mvn.sh

# install golang
echo "install Go" \
  && zsh workspaces/setup_golang.sh

# install docker
echo "install docker" \
  && sudo bash "$SCRIPT_DIR/setups/setup_docker_full.sh" \
  && sudo usermod -aG docker $(whoami)

# install additonal utils
echo "install additional utilities" \
  && bash setups/setup_utils.sh

# install cloud clients
echo "install cloud clients" \
  && bash setups/setup_cloud_clients.sh

# all done!
echo "
*************************
    setup.sh starting
*************************
"
