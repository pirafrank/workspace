FROM pirafrank/workspace:latest

# going headless
ENV DEBIAN_FRONTEND=noninteractive

# explicitly set lang and workdir
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

USER root

# install deps to compile rubies
RUN set -x \
  && apt-get update \
  && apt-get install -y build-essential gawk autoconf automake bison \
    libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool \
    libyaml-dev pkg-config sqlite3 libgmp-dev libreadline-dev libssl-dev

# remove system ruby to avoid conflicts
RUN apt-get remove -y ruby && apt-get autoremove -y && apt-get clean -y

USER work
WORKDIR /home/work

ARG RUBYVERSION

COPY setup_rvm.sh \
  setup_jekyll.sh ./

# install rvm
RUN set -x \
  && echo "install rvm and ruby" \
  && zsh setup_rvm.sh $RUBYVERSION

# install jekyll
RUN set -x \
  && zsh setup_jekyll.sh '4.2.0'

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
