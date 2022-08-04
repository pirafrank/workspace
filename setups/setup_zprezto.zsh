#!/bin/zsh

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB

# fixes "pmodload: no such module: contrib-prompt"
export ZPREZTODIR="${ZDOTDIR:-$HOME}/.zprezto"
# setup prezto-contrib (https://github.com/belak/prezto-contrib#usage)
cd $ZPREZTODIR
git clone --recurse-submodules https://github.com/belak/prezto-contrib contrib
cd -

exit 0
