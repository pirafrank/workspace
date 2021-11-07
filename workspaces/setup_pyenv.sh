#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify the python version."
    exit 1
fi

PYTHON3VERSION="$1"

# installing dependencies to compile python shims
# (only if run as standard user, interactively.
# These deps are installed via Dockerfile during Docker image build)
if [ "$PS1" ] && [ $EUID -ne 0 ] && [ $(command -v sudo) ]; then
  sudo apt-get clean && sudo apt-get update && \
  sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
fi

# installing pyenv
curl -sSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

# load pyenv in current session
# fix: https://github.com/pyenv/pyenv/issues/1906
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
eval "$(pyenv virtualenv-init -)"

pyenv install $PYTHON3VERSION
pyenv global $PYTHON3VERSION

python3 -m pip install --upgrade pip

