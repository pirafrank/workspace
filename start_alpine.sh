#!/bin/sh

if [[ ! -z ${SSH_SERVER} ]]; then
  # start openssh-server
  # NOTE: remember to pass your SSH pubkey via SSH_PUBKEYS env var
  #       or you won't be able to connect to the container!
  sudo /usr/sbin/sshd -D -e "$@"
else
  # start an interactive shell
  zsh
fi
