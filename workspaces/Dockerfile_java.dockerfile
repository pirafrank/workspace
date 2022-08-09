ARG BASE_IMAGE_VERSION=latest
FROM pirafrank/workspace:${BASE_IMAGE_VERSION}

LABEL AUTHOR="pirafrank" MAINTAINER="pirafrank"

# going headless
ENV DEBIAN_FRONTEND=noninteractive

# explicitly set lang and workdir
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"
USER work
WORKDIR /home/work

ARG JAVAVERSION
ARG JAVAVENDOR

COPY setup_java.sh ./
COPY setup_mvn.sh ./

RUN echo "installing java" \
  && zsh setup_java.sh $JAVAVERSION $JAVAVENDOR \
  && zsh setup_mvn.sh

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
