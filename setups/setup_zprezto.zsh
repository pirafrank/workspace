#!/bin/zsh

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/dotfiles/zsh/zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/common/zsh_aliases "${ZDOTDIR:-$HOME}/.zsh_aliases"
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/common/zsh_env "${ZDOTDIR:-$HOME}/.zsh_env"

# fixes "pmodload: no such module: contrib-prompt"
export ZPREZTODIR="${ZDOTDIR:-$HOME}/.zprezto"
# setup prezto-contrib (https://github.com/belak/prezto-contrib#usage)
cd $ZPREZTODIR
git clone --recurse-submodules https://github.com/belak/prezto-contrib contrib
cd -

# setup user defined themes for zprezto
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/zprezto/zsh_user_themes "${ZDOTDIR:-$HOME}/.zsh_user_themes"

# powerlevel10k, installation is done automatically by ~/.zpreztorc
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/common/.p10k.zsh "${ZDOTDIR:-$HOME}/.p10k.zsh"

exit 0
