#!/bin/bash

# this script installs various cloud tools
# it can also be used to update them to their latest version.

folder="${HOME}/bin2"

echo "
Running as : $(whoami)
Home folder: $HOME
Install dir: $folder
"

# creating target dir if it doesn't exist
# it should've been created in prev script
if [ -d $folder ]; then
  mkdir -p $folder
fi
cd $folder

# packer
if [ -f packer ]; then rm -f packer; fi
platform="$(uname -s | tr '[:upper:]' '[:lower:]')"
latest_version=$(curl -sL https://releases.hashicorp.com/packer \
| grep href | grep packer  | head -n1 | cut -d'/' -f3)
url="https://releases.hashicorp.com/packer/${latest_version}/packer_${latest_version}_${platform}_amd64.zip"
curl -o packer.zip -L $url
unzip packer.zip
rm -f packer.zip
chmod +x packer

# scaleway
if [ -f scw ]; then rm -f scw; fi
url=$(curl -sL https://api.github.com/repos/scaleway/scaleway-cli/releases/latest \
  | grep http | grep -i "$(uname -s)" | grep -i "$(uname -m)" | cut -d':' -f 2,3 | cut -d'"' -f2)
if [ -z "$url" ]; then
  echo "Unsupported OS. Skipping scw installation..."
else
  curl -o ./scw -L $url
  chmod +x scw
fi

# hetzner
if [ -f hcloud ]; then rm -f hcloud; fi
if [ $(uname -s) == 'Darwin' ]; then
  url=$(curl -sL https://api.github.com/repos/hetznercloud/cli/releases/latest \
    | grep http | grep -i macos | grep amd64 | grep 'zip' | cut -d':' -f 2,3 | cut -d'"' -f2)
else
  url=$(curl -sL https://api.github.com/repos/hetznercloud/cli/releases/latest \
    | grep http | grep -i "$(uname -s)" | grep amd64 | grep 'tar.gz' | cut -d':' -f 2,3 | cut -d'"' -f2)
fi
if [ -z "$url" ]; then
  echo "Unsupported OS. Skipping hcloud installation..."
else
  curl -o hcloud-bin.tar.gz -L $url
  tar -xzf hcloud-bin.tar.gz
  rm -f hcloud-bin.tar.gz
  chmod +x hcloud
fi
