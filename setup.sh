#!/bin/bash

if [[ $(uname -s) != 'Linux' ]]; then
  echo "Sorry, Linux only this time!"
  exit 1
fi

# install additional software
sudo apt install -y vim rsync tmux

# this is a folder in your HOME
BASEPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# go home and setup dotfiles symlink
cd
ln -s "$BASEPATH" $HOME/dotfiles

# config git
bash dotfiles/git/git_config.sh

# setup symlinks
ln -s dotfiles/bin bin
ln -s dotfiles/.zshrc

# setup zprezto
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/dotfiles/zsh/zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/common/zsh_aliases "${ZDOTDIR:-$HOME}/.zsh_aliases"
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/common/zsh_env "${ZDOTDIR:-$HOME}/.zsh_env"

# setup prezto-contrib (https://github.com/belak/prezto-contrib#usage)
cd $ZPREZTODIR
git clone --recurse-submodules https://github.com/belak/prezto-contrib contrib

# setup user defined themes for zprezto
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/zprezto/zsh_user_themes "${ZDOTDIR:-$HOME}/.zsh_user_themes"

# linking more config in dotfiles
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/git/.gitignore_global "${ZDOTDIR:-$HOME}/.gitignore_global"
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/tmux/.tmux.conf "${ZDOTDIR:-$HOME}/.tmux.conf"
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/vim/.vimrc "${ZDOTDIR:-$HOME}/.vimrc"

ln -s "${ZDOTDIR:-$HOME}"/dotfiles/gnupg/linux/gpg-agent.conf "${ZDOTDIR:-$HOME}/.gnupg/gpg-agent.conf"
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/gnupg/linux/gpg.conf "${ZDOTDIR:-$HOME}/.gnupg/gpg.conf"

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# install using ~/.fzf/install. Choose NOT to add config in shell files. It's already there!


