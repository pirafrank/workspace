#!/bin/zsh

if [[ ! -z ${SSH_SERVER} ]]; then
  # start openssh-server
  # NOTE: remember to pass your SSH pubkey via SSH_PUBKEYS env var
  #       or you won't be able to connect to the container!
  sudo service ssh start
  sudo /usr/sbin/sshd -D
  sleep 100000
else
  # start an interactive shell
  zsh
fi
