#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify the ruby version."
    exit 1
fi

RUBYVERSION="$1"

# installing dependencies to compile rubies
# (only if run as standard user, assume interactive install.
# These deps are installed via Dockerfile during Docker image build)
if [[ $EUID -ne 0 && $(command -v sudo) ]]; then
  sudo apt-get clean && apt-get update  && \
  sudo apt-get install -y build-essential gawk autoconf automake bison \
    libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool \
    libyaml-dev pkg-config sqlite3 libgmp-dev libreadline-dev libssl-dev
fi

#gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable --autolibs=read-fail

# load rvm in current session
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
export PATH="$PATH:$HOME/.rvm/bin"

rvm install $RUBYVERSION
gem install bundler
