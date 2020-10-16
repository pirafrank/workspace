#!/bin/bash

folder=bin2

echo "
Running as : $(whoami)
Home folder: $HOME
Install dir: $HOME/$folder
"

# creating target dir if it doesn't exist
# it should've been created in prev script
if [ -d $HOME/$folder ]; then
  mkdir -p $HOME/$folder
fi
cd $HOME/$folder

# packer
latest_version=$(curl -sL https://releases.hashicorp.com/packer \
| grep href | grep packer  | head -n1 | cut -d'/' -f3)
url="https://releases.hashicorp.com/packer/${latest_version}/packer_${latest_version}_linux_amd64.zip"
curl -o packer_linux_amd64.zip -L $url
unzip packer_linux_amd64.zip
rm -f packer_linux_amd64.zip
chmod +x packer

# scaleway
url=$(curl -sL https://api.github.com/repos/scaleway/scaleway-cli/releases/latest \
| grep http | grep linux | grep x86_64 | cut -d':' -f 2,3 | cut -d'"' -f2)
curl -o ./scw -L $url
chmod +x scw

# hetzner
url=$(curl -sL https://api.github.com/repos/hetznercloud/cli/releases/latest \
| grep http | grep linux | grep amd64 | grep 'tar.gz' | cut -d':' -f 2,3 | cut -d'"' -f2)
curl -o hcloud-linux-amd64.tar.gz -L $url
tar -xzf hcloud-linux-amd64.tar.gz
rm -f hcloud-linux-amd64.tar.gz
chmod +x hcloud
