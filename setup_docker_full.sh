#!/bin/bash

# this installer works for docker engine supported versions of ubuntu and debian

# going script mode...
DEBIAN_FRONTEND=noninteractive

# ubuntu or debian ?
DISTRONAME=$(echo $(lsb_release -is) | tr '[:upper:]' '[:lower:]')

# let's go!
apt-get clean
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/$DISTRONAME/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository -y \
  "deb [arch=amd64] https://download.docker.com/linux/$DISTRONAME \
  $(lsb_release -cs) \
  stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

if [[ $? -ne 0 ]]; then
  echo "Error while installing docker"
  exit 1
fi

# accepting username as param for times when the user
# runs the script as root instead of using sudo
if [[ ! -z "$1" ]]; then
  username="$1"
  # adding user to 'docker' group
  echo "Adding user $username to 'docker' group.
You'll need to logout and login again.
"
  usermod -aG docker $username
  if [[ $? -ne 0 ]]; then
    echo "Error: cannot add $username to 'docker' group"
    exit 1
  fi
fi

# docker-compose installation
echo "Installing docker-compose"
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose
if [[ $? -ne 0 ]]; then
  echo "Installation complete"
else
  echo "Error: cannot install docker-compose"
  exit 1
fi

