FROM alpine:latest

LABEL MANTAINER="pirafrank"

ARG USER_UID=1000
ARG WORKSPACE_VERSION

RUN apk update \
  && apk --no-cache add tzdata sudo less zsh \
    openssh openssh-server-pam \
    vim curl wget git python3 py3-pip \
    openssl ca-certificates

ENV TZ=Europe/Rome

COPY configs/sshd_config /etc/ssh/sshd_config

RUN addgroup -S work \
  && adduser -S work -G work -h /home/work -u $USER_UID -s /bin/zsh \
  && addgroup work wheel \
  && echo work ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/work \
  && echo "root:root" | chpasswd \
  && echo "work:work" | chpasswd

# generate SSH host keys
RUN ssh-keygen -A

USER work
WORKDIR /home/work

COPY pre_start.zsh ./
COPY start_alpine.sh ./start.sh

# dotfiles
COPY dotfiles ./dotfiles
RUN set -x \
  && echo "installing dotfiles" \
  && cd ${HOME}/dotfiles \
  && zsh install.sh vim-minimal

# last but not least, write current version inside image
RUN set -x \
  && mkdir ${HOME}/bin2 \
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
