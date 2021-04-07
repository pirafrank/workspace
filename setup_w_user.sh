#!/bin/bash

if [ $UID -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

unset HISTFILE
read -p  'Username to create: ' newuser
read -sp 'Password to set: ' secretpass
echo
useradd -Um -G sudo -s $(which bash) $newuser
passwd $newuser

# curl is usually already installed in vps templates,
# checking for it anyway
if [ $(command -v curl) ] && [ $(command -v sudo) ]; then
    source <(curl -sSL https://raw.githubusercontent.com/pirafrank/dotfiles/main/workspace_versions.sh)
    curl -sSL https://raw.githubusercontent.com/pirafrank/dotfiles/main/setup.sh | sudo -H -u $newuser bash
else
    echo "Error: curl and sudo are needed, please install them and rerun the script."
    exit 1
fi
