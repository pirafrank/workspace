#!/bin/bash

# this script installs ansible
# it can also be used to update it to its latest version.

###
### init environment
###

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/setup_env.sh"
init

###
### checking requirements
###

(python3 -m pip -V > /dev/null 2>&1 ) && \
  echo "Python is installed. Going on..." || \
  (echo "Python is missing. Exiting..." && exit 1)

###
### install/upgrade ansible
###

python3 -m pip install --upgrade --user ansible

(ansible --version > /dev/null 2>&1 ) && \
  echo "ansible has been installed" || \
  (echo "Something went wrong while installing ansible. Exiting..." && exit 2)

# show installed ansible version
python3 -m pip show ansible

# optional
# install ansible shell completion
python3 -m pip install --user argcomplete
