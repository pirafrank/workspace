#!/bin/zsh

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

exit 0
