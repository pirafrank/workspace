FROM ubuntu:focal-20220801

# going headless
ENV DEBIAN_FRONTEND=noninteractive

ARG USER_UID=1000
ARG UBUNTURELEASE='focal'

# install network tools
RUN apt-get update && apt-get install -y \
  sudo \
  vim \
  curl \
  net-tools \
  netcat \
  iputils-ping \
  openssh-client \
  dnsutils

# clean up
RUN set -x \
  && echo "cleaning up" \
  && apt-get autoremove -y && apt-get clean -y

# add user and change default shell
RUN echo 'add user and change default shell' \
  && useradd -Um -d /home/work -G sudo -s /bin/bash --uid $USER_UID work \
  && echo work ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/work \
  && echo "root:root" | chpasswd \
  && echo "work:work" | chpasswd

# setting locale
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

# Set up timezone (tzdata required)
ENV TZ=Europe/Rome

USER work
WORKDIR /home/work

# copy scripts into WORKDIR
COPY start.sh ./

# set default terminal
ENV TERM=xterm-256color

CMD ["sh", "-c", "bash start.sh"]
