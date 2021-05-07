#!/bin/bash

# this script installs various utils.
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


platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

# yq
echo "Installing yq..."
# ...v2
if [ -f yq2 ]; then rm -f yq2; fi
url="https://github.com/mikefarah/yq/releases/download/2.3.0/yq_${platform}_amd64"
curl -o ./yq2 -L $url
chmod +x yq2
# ...latest
if [ -f yq ]; then rm -f yq; fi
url=$(curl -sL https://api.github.com/repos/mikefarah/yq/releases/latest \
  | grep http | grep -i "$platform" | cut -d':' -f 2,3 | cut -d'"' -f2 | grep -E '*(amd64)$')
curl -o ./yq -L $url
chmod +x yq

# dive - to inspect docker images layers
echo "Installing dive..."
if [ -f dive ]; then rm -f dive; fi
url=$(curl -sL https://api.github.com/repos/wagoodman/dive/releases/latest \
  | grep http | grep -i "$platform" | cut -d':' -f 2,3 | cut -d'"' -f2 | grep 'tar.gz')
curl -L $url | tar xz
chmod +x dive
