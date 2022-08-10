#!/bin/bash

if [ $UID -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

unset HISTFILE
read -p  'Username to create: ' newuser
echo
useradd -Um -G sudo -s $(which bash) $newuser
passwd $newuser
