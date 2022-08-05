#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify the node version."
    exit 1
fi

NODEVERSION="$1"

curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# load nvm in current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

nvm install $NODEVERSION \
nvm alias default $NODEVERSION

# upgrading npm to latest stable
nvm use default
npm install -g npm
