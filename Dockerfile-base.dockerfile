FROM ubuntu:focal-20230308

LABEL AUTHOR="pirafrank" MAINTAINER="pirafrank"
LABEL DESCRIPTION="pirafrank/workspace:base image. It ships with \
  workspace setups, but those are not executed upon build"

# going headless
ENV DEBIAN_FRONTEND=noninteractive

ARG USER_UID=1000
ARG WORKSPACE_VERSION
ARG UBUNTURELEASE='focal'

# alternative BIN2 path
ARG BIN2_PATH='~/bin2'

# copy base setup script
COPY setups/setup_base.sh /tmp/

# set debug mode and install dev and essentials packages
RUN set -x \
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

# copy startup scripts to WORKDIR
COPY start.sh \
  pre_start.zsh ./

# last but not least, write current version inside image
RUN set -x \
  && mkdir -p "${BIN2_PATH}" \
  && rm -f "${BIN2_PATH}/workspace_version" \
  && echo '#!/bin/bash' > "${BIN2_PATH}/workspace_version" \
  && echo "echo Current version: ${WORKSPACE_VERSION}" >> "${BIN2_PATH}/workspace_version" \
  && echo "echo Build on       : $(date '+%Y/%m/%d %H:%M:%S')" >> "${BIN2_PATH}/workspace_version" \
  && chmod +x "${BIN2_PATH}/workspace_version"

# optional gitglobal config
# these are set at startup, if non-empty. you can set them with docker run
ENV GITUSERNAME=''
ENV GITUSEREMAIL=''

# set default terminal
ENV TERM=xterm-256color

EXPOSE 2222

CMD ["sh", "-c", "zsh pre_start.zsh ; zsh start.sh"]
