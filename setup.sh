#!/bin/bash

if [[ $(uname -s) != 'Linux' ]]; then
  echo "Sorry, Linux only this time!"
  exit 1
fi

# install additional software
sudo apt install -y vim rsync tmux

# install tmux plugin manager
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# this is a folder in your HOME
BASEPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# go home and setup dotfiles symlink
cd
ln -s "$BASEPATH" $HOME/dotfiles

# config git
bash dotfiles/git/git_config.sh

# setup symlinks
ln -s dotfiles/bin bin

# setup zprezto
zsh setup/setup_zprezto.sh

# linking more config in dotfiles
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/git/.gitignore_global "${ZDOTDIR:-$HOME}/.gitignore_global"
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/tmux/.tmux.conf "${ZDOTDIR:-$HOME}/.tmux.conf"
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/vim/.vimrc "${ZDOTDIR:-$HOME}/.vimrc"

ln -s "${ZDOTDIR:-$HOME}"/dotfiles/gnupg/linux/gpg-agent.conf "${ZDOTDIR:-$HOME}/.gnupg/gpg-agent.conf"
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/gnupg/linux/gpg.conf "${ZDOTDIR:-$HOME}/.gnupg/gpg.conf"

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cp -a dotfiles/fzf/.fzf* ./


