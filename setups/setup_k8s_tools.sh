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

# kubectl
printf "\n\nInstalling kubectl...\n"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${PLATFORM}/${ARCH_ALT}/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${PLATFORM}/${ARCH_ALT}/kubectl.sha256"
if [ "$(uname -s)" = 'Darwin' ]; then alias sha256sum='shasum -a 256'; fi
if [ "$(<kubectl.sha256)" = "$(sha256sum kubectl | awk '{print $1}')" ]; then
  chmod +x kubectl
  rm -f kubectl.sha256
fi

# krew
printf "\n\nInstalling krew...\n"
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  KREW_ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${KREW_ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

# helm
printf "\n\nInstalling helm...\n"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
HELM_INSTALL_DIR="$BIN2_PATH" bash ./get_helm.sh --no-sudo
rm -f get_helm.sh

# kubectx
printf "\n\nInstalling kubectx...\n"
url=$(curl -sL https://api.github.com/repos/ahmetb/kubectx/releases/latest \
  | grep http | grep -i "$PLATFORM" | grep -i "$ARCH" | cut -d':' -f 2,3 \
  | cut -d'"' -f2 | grep -i kubectx_)
downloadAndInstall "$url" kubectx

# kubens
printf "\n\nInstalling kubens...\n"
url=$(curl -sL https://api.github.com/repos/ahmetb/kubectx/releases/latest \
  | grep http | grep -i "$PLATFORM" | grep -i "$ARCH" | cut -d':' -f 2,3 \
  | cut -d'"' -f2 | grep -i kubens)
downloadAndInstall "$url" kubens

# kubectl-argo-rollouts
printf "\n\nInstalling kubectl-argo-rollouts...\n"
url="https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-${PLATFORM}-${ARCH_ALT}"
downloadAndInstall "$url" 'kubectl-argo-rollouts'

# kustomize is part of kubectl since v1.14.

# stern
printf "\n\nInstalling stern...\n"
url=$(curl -sL https://api.github.com/repos/stern/stern/releases/latest \
  | grep http | grep -i "$PLATFORM" | grep -i "$ARCH_ALT" | cut -d':' -f 2,3 | cut -d'"' -f2)
downloadAndInstall "$url" stern
