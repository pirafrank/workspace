#!/bin/zsh

NODEVERSION="$1"

curl sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh > nvm_install.sh
bash nvm_install.sh
source $HOME/.zshrc
nvm install $NODEVERSION \
nvm alias default $NODEVERSION