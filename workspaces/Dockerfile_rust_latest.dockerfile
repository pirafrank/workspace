FROM pirafrank/workspace:latest

# going headless
ENV DEBIAN_FRONTEND=noninteractive

# explicitly set lang and workdir
ENV LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" LANGUAGE="en_US.UTF-8"
WORKDIR /root

COPY setup_rust.zsh ./

# install rust and cargo
RUN set -x \
  && echo "install rust and cargo" \
  && zsh setup_rust.zsh

# external mountpoints
VOLUME /root/Code
VOLUME /root/secrets
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
