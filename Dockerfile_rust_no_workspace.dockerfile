FROM ubuntu:20.04

# going headless
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# setting locales
RUN apt-get update && apt-get install -y locales
ENV LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

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
    tzdata \
    zsh

# Set up timezone (tzdata required)
ENV TZ 'Europe/Rome'
RUN echo $TZ > /etc/timezone && \
  rm /etc/localtime && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata

COPY setup_rust.zsh ./

# install rvm and jekyll
RUN set -x \
  && echo "install rust and cargo" \
  && zsh setup_rust.zsh

# set default terminal
ENV TERM=xterm-256color

CMD ["zsh"]
