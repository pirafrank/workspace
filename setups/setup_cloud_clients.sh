#!/bin/bash

# this script installs various cloud tools
# it can also be used to update them to their latest version.


### variables ###

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

### script body ###

# init environment
source "$SCRIPT_DIR/setup_env.sh"
echo "BIN2_PATH=${BIN2_PATH}"
setArchAndPlatform
welcome
createDir "$BIN2_PATH"
cd "$BIN2_PATH"

# packer
printf "\n\nInstalling packer...\n"
latest_version=$(curl -sL https://releases.hashicorp.com/packer \
| grep href | grep packer  | head -n1 | cut -d'/' -f3)
url="https://releases.hashicorp.com/packer/${latest_version}/packer_${latest_version}_${PLATFORM}_${ARCH_ALT}.zip"
downloadAndInstall $url packer

# scaleway
printf "\n\nInstalling scaleway client...\n"
url=$(curl -sL https://api.github.com/repos/scaleway/scaleway-cli/releases/latest \
  | grep http | grep -i "${PLATFORM}" | grep -i "${ARCH}" | cut -d':' -f 2,3 | cut -d'"' -f2)
downloadAndInstall $url scw

# hetzner
printf "\n\nInstalling hetzner client...\n"
if [ -f hcloud ]; then rm -f hcloud; fi
if [ $(uname -s) = 'Darwin' ]; then
  url=$(curl -sL https://api.github.com/repos/hetznercloud/cli/releases/latest \
    | grep http | grep -i macos | grep ${ARCH_ALT} | grep 'zip' | cut -d':' -f 2,3 | cut -d'"' -f2)
else
  url=$(curl -sL https://api.github.com/repos/hetznercloud/cli/releases/latest \
    | grep http | grep -i "${PLATFORM}" | grep ${ARCH_ALT} | grep 'tar.gz' | cut -d':' -f 2,3 | cut -d'"' -f2)
fi
downloadAndInstall $url hcloud

# kubectl
printf "\n\nInstalling kubectl...\n"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${ARCH}/${ARCH_ALT}/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${ARCH}/${ARCH_ALT}/kubectl.sha256"
if [ $(uname -s) = 'Darwin' ]; then alias sha256sum='shasum -a 256'; fi
if [ "$(<kubectl.sha256)" = "$(sha256sum kubectl | awk '{print $1}')" ]; then
  chmod +x kubectl
  rm -f kubectl.sha256
fi

# krew
printf "\n\nInstalling krew...\n"
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
)

# helm
printf "\n\nInstalling helm...\n"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
HELM_INSTALL_DIR="$BIN2_PATH" bash ./get_helm.sh --no-sudo
rm -f get_helm.sh

# kubectx + kubens
printf "\n\nInstalling kubectx...\n"
url=$(curl -sL https://api.github.com/repos/ahmetb/kubectx/releases/latest \
  | grep http | grep -i "$PLATFORM" | grep -i "$ARCH" | cut -d':' -f 2,3 \
  | cut -d'"' -f2 | grep -i kubectx_)
downloadAndInstall $url kubectx
rm -f LICENSE

printf "\n\nInstalling kubens...\n"
url=$(curl -sL https://api.github.com/repos/ahmetb/kubectx/releases/latest \
  | grep http | grep -i "$PLATFORM" | grep -i "$ARCH" | cut -d':' -f 2,3 \
  | cut -d'"' -f2 | grep -i kubens)
downloadAndInstall $url kubens
rm -f LICENSE

# stern
printf "\n\nInstalling stern...\n"
url=$(curl -sL https://api.github.com/repos/wercker/stern/releases/latest \
  | grep http | grep -i "$PLATFORM" | cut -d':' -f 2,3 | cut -d'"' -f2)
downloadAndInstall $url stern
