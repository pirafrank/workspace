ARG BASE_IMAGE_VERSION=base
FROM pirafrank/workspace:${BASE_IMAGE_VERSION}

LABEL AUTHOR="pirafrank" MAINTAINER="pirafrank"
LABEL DESCRIPTION="pirafrank/workspace:base image. It ships with \
  workspace setups, but those are not executed upon build"

# going headless
ENV DEBIAN_FRONTEND=noninteractive

# explicitly set lang and workdir
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

ARG USER_UID=1000
ARG WORKSPACE_VERSION
ARG UBUNTURELEASE='focal'

# alternative BIN2 path
ARG BIN2_PATH='~/bin2'

# copy shell setup scripts
COPY setups/setup_fzf.sh \
  setups/setup_zprezto.zsh /tmp/

USER work
WORKDIR /home/work

# install fzf
RUN set -x \
  && echo "install fzf" \
  && zsh /tmp/setup_fzf.sh

# zprezto has many submodules, going with a dedicated layer
RUN set -x \
  && echo "install zprezto" \
  && zsh /tmp/setup_zprezto.zsh

# dotfiles
COPY --chown=work:work dotfiles ./dotfiles
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
  && mkdir -p "${BIN2_PATH}" \
  && rm -f "${BIN2_PATH}/workspace_version" \
  && echo '#!/bin/bash' > "${BIN2_PATH}/workspace_version" \
  && echo "echo Current version: ${WORKSPACE_VERSION}" >> "${BIN2_PATH}/workspace_version" \
  && echo "echo Build on       : $(date '+%Y/%m/%d %H:%M:%S')" >> "${BIN2_PATH}/workspace_version" \
  && chmod +x "${BIN2_PATH}/workspace_version"

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
