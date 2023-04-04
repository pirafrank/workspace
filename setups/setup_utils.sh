#!/bin/bash

# this script installs various utils.
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

# yq
printf "Installing yq...\n"
# ...v2
url="https://github.com/mikefarah/yq/releases/download/2.3.0/yq_${PLATFORM}_${ARCH_ALT}"
downloadAndInstall $url yq2
# ...latest
url=$(curl -sL https://api.github.com/repos/mikefarah/yq/releases/latest \
  | grep http | grep -i "$PLATFORM" | cut -d':' -f 2,3 | cut -d'"' -f2 | grep -E "*($ARCH_ALT)$")
downloadAndInstall $url yq

# xq
url=$(curl -sL https://api.github.com/repos/sibprogrammer/xq/releases/latest \
  | grep http | grep -i "$PLATFORM" | cut -d':' -f 2,3 |  cut -d'"' -f2 |  grep 'tar.gz' | grep $ARCH_ALT)
downloadAndInstall $url xq

# dive - to inspect docker images layers
printf "\n\nInstalling dive...\n"
url=$(curl -sL https://api.github.com/repos/wagoodman/dive/releases/latest \
  | grep http | grep -i "$PLATFORM" | cut -d':' -f 2,3 | cut -d'"' -f2 | grep 'tar.gz' | grep $ARCH_ALT)
downloadAndInstall $url dive

# lazygit
printf "\n\nInstalling lazygit...\n"
url=$(curl -sL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
  | grep http | grep -i "$PLATFORM" | cut -d':' -f 2,3 | cut -d'"' -f2 | grep 'tar.gz' | grep $ARCH)
downloadAndInstall $url lazygit

# delta
printf "\n\nInstalling dandavison/delta...\n"
url=$(curl -sL https://api.github.com/repos/dandavison/delta/releases/latest \
    | grep http | grep -i "$PLATFORM" | cut -d':' -f 2,3 | cut -d'"' -f2 | grep 'tar.gz' | grep $ARCH | head -n1)
del delta
curl -L $url | tar xz
find $folder -type f -iname delta -exec mv {} $folder/delta \;
chmod +x $folder/delta

# ipinfo cli
printf "\n\nInstalling ipinfo cli...\n"
del ipinfo
url=$(curl -sL https://api.github.com/repos/ipinfo/cli/releases \
  | grep browser_download_url | grep 'download/ipinfo' | grep -i "$PLATFORM" \
  | cut -d':' -f 2,3 | cut -d'"' -f2 | grep 'tar.gz' | grep $ARCH_ALT | sort -rV | head -n1)
curl -L $url -o ipinfo.tar.gz
filename="$(tar -tf ipinfo.tar.gz | grep ipinfo | grep $PLATFORM)"
tar -xzf ipinfo.tar.gz
mv "$filename" ipinfo
chmod +x ipinfo
rm -f ipinfo.tar.gz
