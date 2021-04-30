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
echo "Installing packer..."
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
echo "Installing scaleway client..."
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
echo "Installing hetzner client..."
if [ -f hcloud ]; then rm -f hcloud; fi
if [ $(uname -s) = 'Darwin' ]; then
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



# kubectl
if [ -f kubectl ]; then rm -f kubectl; fi
ARCH="$(uname -s | tr '[:upper:]' '[:lower:]')"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${ARCH}/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${ARCH}/amd64/kubectl.sha256"

if [ $(uname -s) = 'Darwin' ]; then alias sha256sum='shasum -a 256'; fi

if [ "$(<kubectl.sha256)" = "$(sha256sum kubectl | awk '{print $1}')" ]; then
  chmod +x kubectl
  rm -f kubectl.sha256
fi


# helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
HELM_INSTALL_DIR="$HOME/bin2" bash ./get_helm.sh --no-sudo
rm -f get_helm.sh


# kubectx + kubens
echo "Installing kubectx..."
if [ -f kubectx ]; then rm -f kubectx; fi
url=$(curl -sL https://api.github.com/repos/ahmetb/kubectx/releases/latest \
  | grep http | grep -i "$(uname -s)" | grep -i "$(uname -m)" | cut -d':' -f 2,3 \
  | cut -d'"' -f2 | grep -i kubectx_)
if [ -z "$url" ]; then
  echo "Unsupported OS. Skipping kubectx installation..."
else
  curl -o ./kubectx.tar.gz -L $url
  tar -xzf kubectx.tar.gz
  chmod +x kubectx
  rm -f kubectx.tar.gz
  rm -f LICENSE
fi

echo "Installing kubens..."
if [ -f kubens ]; then rm -f kubens; fi
url=$(curl -sL https://api.github.com/repos/ahmetb/kubectx/releases/latest \
  | grep http | grep -i "$(uname -s)" | grep -i "$(uname -m)" | cut -d':' -f 2,3 \
  | cut -d'"' -f2 | grep -i kubens)
if [ -z "$url" ]; then
  echo "Unsupported OS. Skipping kubens installation..."
else
  curl -o ./kubens.tar.gz -L $url
  tar -xzf kubens.tar.gz
  chmod +x kubens
  rm -f kubens.tar.gz
  rm -f LICENSE
fi


# stern
echo "Installing stern..."
if [ -f stern ]; then rm -f stern; fi
url=$(curl -sL https://api.github.com/repos/wercker/stern/releases/latest \
  | grep http | grep -i "$(uname -s)" | cut -d':' -f 2,3 | cut -d'"' -f2)
if [ -z "$url" ]; then
  echo "Unsupported OS. Skipping stern installation..."
else
  curl -o ./stern -L $url
  chmod +x stern
fi
