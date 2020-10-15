#!/bin/bash

# this installer works for docker engine supported versions of ubuntu and debian

# going script mode...
DEBIAN_FRONTEND=noninteractive

# ubuntu or debian ?
DISTRONAME=$(echo $(lsb_release -is) | tr '[:upper:]' '[:lower:]')

# let's go!
apt-get clean
apt-get update
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/$DISTRONAME/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/$DISTRONAME \
  $(lsb_release -cs) \
  stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io


