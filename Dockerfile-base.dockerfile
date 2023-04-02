FROM ubuntu:focal-20220801

LABEL AUTHOR="pirafrank" MAINTAINER="pirafrank"
LABEL DESCRIPTION="pirafrank/workspace:base image. It ships with \
  workspace setups, but those are not executed upon build"

# going headless
ENV DEBIAN_FRONTEND=noninteractive

ARG USER_UID=1000
ARG WORKSPACE_VERSION
ARG UBUNTURELEASE='focal'

# copy base setup script
COPY setups/setup_base.sh /tmp/

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
  && echo work ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/work \
  && echo "root:root" | chpasswd \
  && echo "work:work" | chpasswd

# setting locale
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

# Set up timezone (tzdata required)
ENV TZ=Europe/Rome

# copy openssh-server config
COPY configs/sshd_config /etc/ssh/sshd_config

USER work
WORKDIR /home/work

# copy setup scripts to WORKDIR
COPY setups/setup_env.sh \
  setups/setup_utils.sh \
  setups/setup_aws_tools.sh \
  setups/setup_cloud_clients.sh \
  setups/setup_docker_cli.sh \
  start.sh \
  pre_start.zsh ./

# copy workspace setup scripts to WORKDIR
COPY workspaces/*.sh ./workspace_setups/

# last but not least, write current version inside image
RUN set -x \
  && echo '#!/bin/bash' > bin2/workspace_version \
  && echo "echo Current version: ${WORKSPACE_VERSION}" >> bin2/workspace_version \
  && echo "echo Build on       : $(date '+%Y/%m/%d %H:%M:%S')" >> bin2/workspace_version \
  && chmod +x bin2/workspace_version

# optional gitglobal config
# these are set at startup, if non-empty. you can set them with docker run
ENV GITUSERNAME=''
ENV GITUSEREMAIL=''

# set default terminal
ENV TERM=xterm-256color

EXPOSE 2222

CMD ["sh", "-c", "zsh pre_start.zsh ; zsh start.sh"]
