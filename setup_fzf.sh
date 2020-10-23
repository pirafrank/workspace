#!/bin/bash

# installing fzf
git clone --depth 1 https://github.com/junegunn/fzf.git .fzf \

# get latest release version
url=$(curl -sL https://api.github.com/repos/junegunn/fzf-bin/releases/latest \
| grep http | grep linux | grep amd64  | cut -d':' -f 2,3 | cut -d'"' -f2)
curl -o fzf.tar.gz -L $url
tar -xzf fzf.tar.gz
rm -f fzf.tar.gz
mv fzf $HOME/.fzf/bin/

# copy config from dotfiles
cp -a dotfiles/fzf/.fzf* ./

# you may not have my username...
sed -i "s@/home/francesco@$HOME@g" .fzf.bash
sed -i "s@/home/francesco@$HOME@g" .fzf.zsh
