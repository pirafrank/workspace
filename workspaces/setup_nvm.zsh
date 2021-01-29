#!/bin/zsh

if [[ -z "$1" ]]; then
    echo "Please specify the node version."
    exit 1
fi

NODEVERSION="$1"

curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh > nvm_install.sh
bash nvm_install.sh
source $HOME/.zshrc
nvm install $NODEVERSION \
nvm alias default $NODEVERSION
