FROM ubuntu:20.04

# going headless
ENV DEBIAN_FRONTEND=noninteractive

ARG USER_UID=1000
ARG WORKSPACE_VERSION
ARG UBUNTURELEASE='focal'

# copy base setup scripts
COPY base/setup_fzf.sh \
  base/setup_zprezto.zsh \
  base/setup_base.sh /tmp/

# set debug mode and install dev and essentials packages
RUN set -x \
  && chmod +rx /tmp/setup_*sh \
  && bash /tmp/setup_base.sh \
  && echo 'restore man command' \
  && yes | unminimize 2>&1 \
  && echo "cleaning up" \
  && apt-get autoremove -y && apt-get clean -y \
  && rm -f /tmp/setup_base.sh \
  && echo 'add user and change default shell' \
  && useradd -Um -d /home/work -G sudo -s /bin/bash --uid $USER_UID work \
  && chsh -s $(which zsh) work \
  && echo work ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/work

# setting locale
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

# Set up timezone (tzdata required)
ENV TZ=Europe/Rome

USER work
WORKDIR /home/work

# copy setup scripts for different envs
# into WORKDIR
COPY setups/setup_docker_cli.sh \
  setups/setup_env.sh \
  setups/setup_utils.sh \
  workspaces/setup_nvm.sh \
  workspaces/setup_pyenv.sh \
  workspaces/setup_rvm.sh \
  workspaces/setup_rust.sh \
  workspaces/setup_java.sh \
  workspaces/setup_golang.sh \
  pre_start.zsh ./

# install fzf
RUN set -x \
  && echo "install fzf" \
  && zsh /tmp/setup_fzf.sh

# zprezto has many submodules, going with a dedicated layer
RUN set -x \
  && echo "install zprezto" \
  && zsh /tmp/setup_zprezto.zsh

# clone dotfiles
RUN set -x \
  && echo "installing dotfiles" \
  && git clone https://github.com/pirafrank/dotfiles.git ${HOME}/dotfiles \
  && cd ${HOME}/dotfiles \
  && zsh install.sh all

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
