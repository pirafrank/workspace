#!/bin/bash

# installing fzf
git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"

cd
# get latest release version
if [ "$(uname -m)" == 'x86_64' ]; then
  url=$(curl -sL https://api.github.com/repos/junegunn/fzf-bin/releases/latest \
    | grep http | grep -i "$(uname -s)" | grep amd64 | cut -d':' -f 2,3 | cut -d'"' -f2)
fi

if [ -z "$url" ]; then
  echo "Unsupported platform. Quitting..."
  exit 1
fi

curl -o fzf.tar.gz -L $url
tar -xzf fzf.tar.gz
rm -f fzf.tar.gz
mv fzf $HOME/.fzf/bin/

# copy config from dotfiles
cp -a ${HOME}/dotfiles/fzf/.fzf* ${HOME}/

# you may not have my username...
sed -i='' "s@/home/francesco@$HOME@g" ${HOME}/.fzf.bash
sed -i='' "s@/home/francesco@$HOME@g" ${HOME}/.fzf.zsh
cd -
