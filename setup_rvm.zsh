#!/bin/zsh

if [[ -z "$1" ]]; then
    echo "Please specify the image version to build."
    exit 1
fi

RUBYVERSION="$1"

gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io > rvmscript
cat rvmscript | bash -s stable
rm -f rvmscript
source $HOME/.zshrc
#source /usr/local/rvm/scripts/rvm
rvm install $RUBYVERSION
gem install bundler
