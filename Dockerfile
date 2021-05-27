FROM ubuntu:groovy-20210416

# going headless
ENV DEBIAN_FRONTEND=noninteractive

ARG WORKSPACE_VERSION
ARG UBUNTURELEASE='focal'

# setting locales
RUN set -x \
  && apt-get clean && apt-get update \
  && apt-get install -y locales
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

# set debug mode and install dev and essentials packages
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends apt-utils \
  && apt-get install -y \
    build-essential \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    tzdata

# Set up timezone (tzdata required)
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install dev software and dotfiles
# comments are more for Dockerfile maintenance
RUN set -x \
  && apt-get remove vim-runtime gvim vim-tiny \
    vim-common vim-gui-common \
  && apt-get update && apt-get install -y \
    wget \
    vim \
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
    bat \
    fd-find \
  && echo "getting newer git..." \
  && add-apt-repository ppa:git-core/ppa \
  && apt-get update \
  && apt-get install -y git \
  && echo "installing python3 (focal ships with 3.8)" \
  && apt-get install -y python3-pip

# add user and change default shell
RUN set -x \
  && useradd -Um -d /home/work -G sudo -s /bin/bash work \
  && echo "change default shell" \
  && chsh -s $(which zsh) work

# install docker-cli (client only)
# RUN set -x \
#   && echo "install docker-cli (CLI client only)" \
#   && zsh setup_docker_cli.zsh $UBUNTURELEASE

USER work
WORKDIR /home/work

# copy setup scripts for different envs
# into WORKDIR
COPY install_dotfiles.zsh \
  setups/setup_docker_cli.zsh \
  setups/setup_fzf.sh \
  setups/setup_zprezto.zsh \
  setups/setup_env.sh \
  setups/setup_utils.sh \
  workspaces/setup_nvm.zsh \
  workspaces/setup_pyenv.zsh \
  workspaces/setup_rvm.zsh \
  workspaces/setup_rust.zsh \
  workspaces/setup_java.zsh \
  workspaces/setup_golang.zsh \
  pre_start.zsh ./

# install fzf
RUN set -x \
  && echo "install fzf" \
  && zsh setup_fzf.sh

# zprezto has many submodules, going with a dedicated layer
RUN set -x \
  && echo "install zprezto" \
  && zsh setup_zprezto.zsh

# clone dotfiles
RUN set -x \
  && echo "installing dotfiles" \
  && git clone https://github.com/pirafrank/dotfiles.git ${HOME}/dotfiles \
  && zsh install_dotfiles.zsh all

# installing additional utils
RUN set -x \
  && echo "installing additional utilities" \
  && zsh setup_utils.sh

# last but not least, write current version inside image
RUN set -x \
  && echo '#!/bin/bash' > bin2/workspace_version \
  && echo "echo Current version: ${WORKSPACE_VERSION}" >> bin2/workspace_version \
  && echo "echo Build on       : $(date '+%Y/%m/%d %H:%M:%S')" >> bin2/workspace_version \
  && chmod +x bin2/workspace_version

# external mountpoints
VOLUME /home/work/Code
VOLUME /home/work/secrets
# Warning from the docs:
# If any build steps change the data within the volume
# AFTER it has been declared, those changes will be discarded.

# optional gitglobal config
# these are set at startup, if non-empty. you can set them with docker run
ENV GITUSERNAME=''
ENV GITUSEREMAIL=''

# set default terminal
ENV TERM=xterm-256color

CMD ["sh", "-c", "zsh pre_start.zsh ; zsh"]
