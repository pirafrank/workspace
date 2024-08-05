#!/bin/bash

# this script installs various cloud tools
# it can also be used to update them to their latest version.


### variables ###

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

### script body ###

# init environment
source "$SCRIPT_DIR/setup_env.sh"
export BIN2_PATH="${BIN2_PATH:-${HOME}/bin2}"
echo "Binary install path: ${BIN2_PATH}"
setArchAndPlatform
welcome
createDir "$BIN2_PATH"
cd "$BIN2_PATH" || exit 1

# packer
printf "\n\nInstalling packer...\n"
latest_version=$(curl -sL https://releases.hashicorp.com/packer \
| grep href | grep packer  | head -n1 | cut -d'/' -f3)
url="https://releases.hashicorp.com/packer/${latest_version}/packer_${latest_version}_${PLATFORM}_${ARCH_ALT}.zip"
downloadAndInstall "$url" packer

# scaleway
printf "\n\nInstalling scaleway client...\n"
url=$(curl -sL https://api.github.com/repos/scaleway/scaleway-cli/releases/latest \
  | grep http | grep -i "${PLATFORM}" | grep -i "${ARCH}" | cut -d':' -f 2,3 | cut -d'"' -f2)
downloadAndInstall "$url" scw

# hetzner
printf "\n\nInstalling hetzner client...\n"
if [ -f hcloud ]; then rm -f hcloud; fi
if [ "$(uname -s)" = 'Darwin' ]; then
  url=$(curl -sL https://api.github.com/repos/hetznercloud/cli/releases/latest \
    | grep http | grep -i macos | grep ${ARCH_ALT} | grep 'zip' | cut -d':' -f 2,3 | cut -d'"' -f2)
else
  url=$(curl -sL https://api.github.com/repos/hetznercloud/cli/releases/latest \
    | grep http | grep -i "${PLATFORM}" | grep ${ARCH_ALT} | grep 'tar.gz' | cut -d':' -f 2,3 | cut -d'"' -f2)
fi
downloadAndInstall "$url" hcloud
