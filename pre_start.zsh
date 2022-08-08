#!/bin/zsh

# gitglobal
if [[ ! -z ${GITUSERNAME} ]]; then
  git config --global user.name ${GITUSERNAME}
fi
if [[ ! -z ${GITUSEREMAIL} ]]; then
  git config --global user.email ${GITUSEREMAIL}
fi

if [[ ! -z ${SSH_PUBKEYS} ]]; then
  TARGET="${HOME}/.ssh"
  mkdir ${TARGET}
  chmod 700 ${TARGET}
  cd ${TARGET}
  touch authorized_keys
  chmod 600 authorized_keys
  echo ${SSH_PUBKEYS} >> authorized_keys
fi
