#!/bin/zsh

# gitglobal
if [[ ! -z ${GITUSERNAME} ]]; then
  git config --global user.name ${GITUSERNAME}
fi
if [[ ! -z ${GITUSEREMAIL} ]]; then
  git config --global user.email ${GITUSEREMAIL}
fi
