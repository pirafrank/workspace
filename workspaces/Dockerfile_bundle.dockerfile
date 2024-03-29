ARG BASE_IMAGE_VERSION=latest
FROM pirafrank/workspace:${BASE_IMAGE_VERSION}

LABEL AUTHOR="pirafrank" MAINTAINER="pirafrank"
LABEL DESCRIPTION="pirafrank/workspace bundle image. It ships with \
  all workspaces and utilities installed."

# going headless
ENV DEBIAN_FRONTEND=noninteractive

# explicitly set lang and workdir
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

USER root

# remove system ruby to avoid conflicts
RUN apt-get remove -y ruby

# install deps to compile python shims and rubies
RUN set -x \
  && apt-get update \
  && apt-get install -y \
    autoconf \
    automake \
    bison \
    gawk \
    libbz2-dev \
    libffi-dev \
    libgdbm-dev \
    libgmp-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libyaml-dev \
    llvm \
    pkg-config \
    python-openssl \
    sqlite3 \
    tk-dev \
  && apt-get autoremove -y && apt-get clean -y

# switch to user
USER work
WORKDIR /home/work

ARG JAVAVERSION=17
ARG JAVAVENDOR=openjdk
ARG NODEVERSION=18
ARG GOLANGVERSION
ARG PYTHON3VERSION=3.11
ARG RUBYVERSION=2.7

COPY *.sh ./workspace_setups/

# installing java and mvn
RUN echo "installing java" \
  && zsh workspace_setups/setup_java.sh ${JAVAVERSION} ${JAVAVENDOR} \
  && zsh workspace_setups/setup_mvn.sh

# installing nvm and node
RUN echo "installing nvm and node" \
  && zsh workspace_setups/setup_nvm.sh ${NODEVERSION}

# installing golang
RUN echo "installing Go" \
  && zsh workspace_setups/setup_golang.sh ${GOLANGVERSION}

# install pyenv and python
RUN set -x \
  && echo "install pyenv and python" \
  && choice=$(curl -sSL https://api.github.com/repos/pyenv/pyenv/contents/plugins/python-build/share/python-build | \
  grep name | cut -d'"' -f4 | grep -v '-' | tail -n +2 | grep "${PYTHON3VERSION}" | tail -1) \
  && zsh workspace_setups/setup_pyenv.sh ${choice}

# install deoplete python deps
RUN set -x \
  && export PATH="$HOME/.pyenv/bin:$PATH" \
  && eval "$(pyenv init -)" \
  && python3 -m pip install --user pynvim

# install rvm
RUN set -x \
  && echo "install rvm and ruby" \
  && zsh workspace_setups/setup_rvm.sh ${RUBYVERSION}

# install rust and cargo
RUN set -x \
  && echo "install rust and cargo" \
  && zsh workspace_setups/setup_rust.sh

# add workspace versions to file
RUN set -x \
  && echo "echo '*** Build args ***'" >> bin2/workspace_version \
  && echo "echo JAVAVERSION: ${JAVAVERSION}" >> bin2/workspace_version \
  && echo "echo JAVAVENDOR: ${JAVAVENDOR}" >> bin2/workspace_version \
  && echo "echo NODEVERSION: ${NODEVERSION}" >> bin2/workspace_version \
  && echo "echo PYTHON3VERSION: ${PYTHON3VERSION}" >> bin2/workspace_version \
  && echo "echo RUBYVERSION: ${RUBYVERSION}" >> bin2/workspace_version \
  && echo "echo GOLANGVERSION: ${GOLANGVERSION}" >> bin2/workspace_version \
  && echo "echo '*** Software versions ***'" >> bin2/workspace_version \
  && echo "java -version" >> bin2/workspace_version \
  && echo "mvn -version" >> bin2/workspace_version \
  && echo "node --version" >> bin2/workspace_version \
  && echo "python --version" >> bin2/workspace_version \
  && echo "ruby --version" >> bin2/workspace_version \
  && echo "rvm --version" >> bin2/workspace_version \
  && echo "go version" >> bin2/workspace_version \
  && echo "rustc --version" >> bin2/workspace_version

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
