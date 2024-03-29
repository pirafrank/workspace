ARG BASE_IMAGE_VERSION=latest
FROM pirafrank/workspace:${BASE_IMAGE_VERSION}

LABEL AUTHOR="pirafrank" MAINTAINER="pirafrank"

# going headless
ENV DEBIAN_FRONTEND=noninteractive

# explicitly set lang and workdir
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

USER root

# install deps to compile python shims
RUN set -x \
  && apt-get update \
  && apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl git \
  && apt-get autoremove -y && apt-get clean -y

USER work
WORKDIR /home/work

ARG PYTHON3VERSION

COPY setup_pyenv.sh ./

# install pyenv and python
RUN set -x \
  && echo "install pyenv and python" \
  && choice=$(curl -sSL https://api.github.com/repos/pyenv/pyenv/contents/plugins/python-build/share/python-build | \
  grep name | cut -d'"' -f4 | grep -v '-' | tail -n +2 | grep "$PYTHON3VERSION" | tail -1) \
  && zsh setup_pyenv.sh $choice

# install deoplete python deps
RUN set -x \
  && export PATH="$HOME/.pyenv/bin:$PATH" \
  && eval "$(pyenv init -)" \
  && python3 -m pip install --user pynvim

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
