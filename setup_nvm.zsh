#!/bin/zsh

NODEVERSION="$1"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
nvm install $NODEVERSION \
nvm alias default $NODEVERSION
