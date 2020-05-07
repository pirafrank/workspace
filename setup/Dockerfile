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
    tzdata

# Set up timezone (tzdata required)
ENV TZ 'Europe/Rome'
RUN echo $TZ > /etc/timezone && \
  rm /etc/localtime && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata

# install dev software and dotfiles
# comments are more for Dockerfile maintenance
RUN set -x \
  && apt-get install -y \
    wget \
    vim \
    zsh \
    tmux \
    mosh \
    rsync \
    mc \
    tree \
    jq \
    postgresql-client \
    zlib1g-dev \
    unzip \
    zip \
    xz-utils \
    zutils \
  && echo "getting newer git..." \
  && add-apt-repository ppa:git-core/ppa \
  && apt-get update \
  && apt-get install -y git \
  && echo "installing python3 (focal ships with 3.8)" \
  && apt-get install -y \
    python3-pip \
  && echo "installing neovim" \
  && apt-get install -y \
    neovim \
  && pip3 install neovim \
  && echo "make dirs" \
  && mkdir bin2 \
  && mkdir -p Code/Workspaces \
  && echo "install tmux plugin manager" \
  && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ARG GITUSERNAME='Francesco Pira'
ARG GITUSEREMAIL
ARG NODEVERSION=12
ARG PYTHON3VERSION='3.7.7'

COPY setup_zprezto.zsh setup_nvm.zsh setup_pyenv.zsh ./

RUN set -x \
  && echo "clone and setup my dotfiles" \
  && git clone https://github.com/pirafrank/dotfiles.git dotfiles \
  && echo "config git global" \
  && /bin/bash dotfiles/git/git_config.sh \
  && git config --global user.name $GITUSERNAME \
  && git config --global user.email $GITUSEREMAIL \
  && echo "creating symlinks to dotfiles" \
  && ln -s dotfiles/bin bin \
  && ln -s dotfiles/git/.gitignore_global .gitignore_global \
  && ln -s dotfiles/tmux/.tmux.conf .tmux.conf \
  && ln -s dotfiles/vim/.vimrc .vimrc \
  && echo "install zprezto" \
  && zsh setup_zprezto.zsh \
  && echo "install fzf" \
  && git clone --depth 1 https://github.com/junegunn/fzf.git .fzf \
  && cp -a dotfiles/fzf/.fzf* ./ \
  && sed -i s@home/francesco@root@g .fzf.bash \
  && sed -i s@home/francesco@root@g .fzf.zsh \
  && echo "change default shell" \
  && chsh -s $(which zsh) \
  && echo "installing nvm and node" \
  && zsh setup_nvm.zsh $NODEVERSION

# installing python3 via pyenv
#RUN set -x \
#  && echo "installing pyenv and python" \
#  && zsh setup_pyenv.zsh $PYTHON3VERSION || true

# install rvm and jekyll


# external mountpoints
VOLUME /root/Code
VOLUME /root/secrets
# Warning from the docs:
# If any build steps change the data within the volume
# AFTER it has been declared, those changes will be discarded.

# set default terminal
ENV TERM=xterm-256color

CMD ["tmux"]
