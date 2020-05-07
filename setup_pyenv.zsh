#!/bin/zsh

PYTHON3VERSION="$1"

# installing dependencies to compile python shims
sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

# installing pyenv
curl -sSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer > pyenv-installer.sh
bash pyenv-installer.sh
source $HOME/.zshrc
pyenv install $PYTHON3VERSION
pyenv global $PYTHON3VERSION
