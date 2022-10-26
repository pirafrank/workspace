FROM ubuntu:focal-20221019

# going headless
ENV DEBIAN_FRONTEND=noninteractive

ARG USER_UID=1000
ARG WORKSPACE_VERSION
ARG UBUNTURELEASE='focal'

# copy base setup scripts
COPY setups/setup_fzf.sh \
  setups/setup_zprezto.zsh \
  setups/setup_base.sh /tmp/

# set debug mode and install dev and essentials packages
RUN set -x \
  && chmod +rx /tmp/setup_*sh \
  && bash /tmp/setup_base.sh

# restore manual and clean up
RUN set -x \
  && echo "cleaning up" \
  && apt-get autoremove -y && apt-get clean -y

# add user and change default shell
RUN echo 'add user and change default shell' \
  && useradd -Um -d /home/work -G sudo -s /bin/bash --uid $USER_UID work \
  && chsh -s $(which zsh) work \
  && echo work ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/work

# setting locale
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

# Set up timezone (tzdata required)
ENV TZ=Europe/Rome

COPY configs/sshd.conf /etc/ssh/sshd_config.d/sshd.conf

USER work
WORKDIR /home/work

# copy setup scripts for different envs
# into WORKDIR
COPY setups/setup_env.sh \
  setups/setup_utils.sh \
  setups/setup_aws_tools.sh \
  setups/setup_cloud_clients.sh \
  setups/setup_docker_cli.sh \
  start.sh \
  pre_start.zsh ./

COPY workspaces/*.sh ./workspace_setups/

# install fzf
RUN set -x \
  && echo "install fzf" \
  && zsh /tmp/setup_fzf.sh

# zprezto has many submodules, going with a dedicated layer
RUN set -x \
  && echo "install zprezto" \
  && zsh /tmp/setup_zprezto.zsh

# dotfiles
COPY dotfiles ./dotfiles
RUN set -x \
  && echo "installing dotfiles" \
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

EXPOSE 2222

CMD ["sh", "-c", "zsh pre_start.zsh ; zsh start.sh"]
