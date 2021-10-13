#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify the jekyll version to install."
    exit 1
fi

JEKYLLVERSION="$1"

# load rvm in current session
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
export PATH="$PATH:$HOME/.rvm/bin"

echo "installing jekyll version $JEKYLLVERSION"
gem install jekyll -v $JEKYLLVERSION

