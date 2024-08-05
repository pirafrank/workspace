#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root. Quitting..."
   exit 1
fi

set -x

export DEBIAN_FRONTEND=noninteractive
export TZ=Europe/Rome

SKIP_APT_UPDATE="$1"

if [ -z "$SKIP_APT_UPDATE" ] || [ $SKIP_APT_UPDATE != 'true' ]; then
    echo "upgrading packages"
    apt-get update && apt-get upgrade --no-install-recommends -y
fi

# base install and essential packages
echo "installing apt-utils" \
  && apt-get install -y --no-install-recommends apt-utils \
  && echo 'remove unneeded packages' \
  && apt-get remove -y vim-runtime gvim vim-tiny \
    vim-common vim-gui-common \
  && echo 'install dev and other essential packages' \
  && apt-get install -y \
    build-essential \
    make \
    colormake \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    tzdata \
    locales \
    sudo \
    openssh-server \
    wget \
    zsh \
    tmux \
    mosh \
    rsync \
    less \
    mc \
    tree \
    jq \
    postgresql-client \
    zlib1g-dev \
    unzip \
    zip \
    xz-utils \
    zutils \
    atop \
    htop \
    ncdu \
    libxml2-utils \
    libncurses5 \
    fd-find \
    bat

# because of potential conflict on dummy files if installed after batcat
# being both developed in Rust. This issue it's just an Ubuntu 20.04 thing.
#apt-get install -y ripgrep -o Dpkg::Options::="--force-overwrite"

echo "getting newer git and clvv/fasd..." \
  && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com A1715D88E1DF1F24 \
  && add-apt-repository ppa:git-core/ppa -y \
  && add-apt-repository ppa:aacebedo/fasd -y \
  && apt-get update \
  && apt-get install -y git fasd \
  && echo "installing python3 (focal ships with 3.8)" \
  && apt-get install -y python3 python3-pip

echo "installing vim from jonathonf's PPA" \
  && add-apt-repository ppa:jonathonf/vim -y \
  && apt-get update \
  && apt-get install -y vim

# setting up locale
echo "setting up locale"
# courtesy of ms dev-containers
if ! grep -o -E '^\s*en_US.UTF-8\s+UTF-8' /etc/locale.gen > /dev/null; then
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
fi

# Set up timezone (tzdata required)
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata
