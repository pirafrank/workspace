#!/bin/bash

# this script installs various utils.
# it can also be used to update them to their latest version.

folder="${HOME}/bin2"

function del {
  if [ -f "$1" ]; then rm -f "$1"; fi
}

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
arch=$(arch)

# yq
echo "Installing yq..."
# ...v2
del yq2
url="https://github.com/mikefarah/yq/releases/download/2.3.0/yq_${platform}_amd64"
curl -o ./yq2 -L $url
chmod +x yq2
# ...latest
del yq
url=$(curl -sL https://api.github.com/repos/mikefarah/yq/releases/latest \
  | grep http | grep -i "$platform" | cut -d':' -f 2,3 | cut -d'"' -f2 | grep -E '*(amd64)$')
curl -o ./yq -L $url
chmod +x yq

# dive - to inspect docker images layers
echo "Installing dive..."
del dive
url=$(curl -sL https://api.github.com/repos/wagoodman/dive/releases/latest \
  | grep http | grep -i "$platform" | cut -d':' -f 2,3 | cut -d'"' -f2 | grep 'tar.gz')
curl -L $url | tar xz
chmod +x dive

# lazygit
del lazygit
url=$(curl -sL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
  | grep http | grep -i "$platform" | cut -d':' -f 2,3 | cut -d'"' -f2 | grep 'tar.gz' | grep $arch)
curl -L $url | tar xz
chmod +x lazygit

# ipinfo cli
del ipinfo
url=$(curl -sL https://api.github.com/repos/ipinfo/cli/releases/latest \
  | grep http | grep -i "$platform" | cut -d':' -f 2,3 | cut -d'"' -f2 | grep 'tar.gz' | grep 'amd64')
curl -L $url | tar xz
mv ipinfo*amd64 ipinfo
chmod +x ipinfo
