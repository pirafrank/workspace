#!/bin/zsh

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

gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io > rvmscript
cat rvmscript | bash -s stable --autolibs=read-fail
rm -f rvmscript
# support dotfiles-less setup
if [ -f $HOME/.zshrc ]; then
  source $HOME/.zshrc
else
  source /usr/local/rvm/scripts/rvm
fi
rvm install $RUBYVERSION
gem install bundler
