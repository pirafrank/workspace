#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify the image version to build."
    exit 1
fi

UBUNTURELEASE="$1"

echo "install docker-cli (CLI client only)"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg > key
cat key | apt-key add -
apt-key fingerprint 0EBFCD88
rm -f key
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTURELEASE stable"
apt-get clean
apt-get update
apt-get install -y --no-install-recommends docker-ce-cli
