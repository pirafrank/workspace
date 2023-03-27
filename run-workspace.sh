#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify an image version to run."
    echo "You can optionally add parameters to 'docker run' as \$2."
    echo "\$3 is to enable DOCKERCLI socket, optional. It can be anything, just not blank."
    printf "\nAvailable images are:\n$(docker images | grep 'pirafrank/workspace')\n"
    exit 1
fi

VERSION="$1"
WORKSPACE_NAME="workspace-${VERSION}"
PARAMS="$2"

# add a default name if none provided
if [[ $PARAMS != *"--name "* ]]; then
  PARAMS="--name $WORKSPACE_NAME $PARAMS"
fi

# if $3 is present, add value to DOCKERCLI
# this allows Docker CLI inside the container to control Docker daemon on the host.
DOCKERCLI="" && [[ $3 != "" ]] && DOCKERCLI="-v /var/run/docker.sock:/var/run/docker.sock"

mkdir -p $HOME/work_temp/Code
mkdir -p $HOME/work_temp/secrets

if [ -z "$(docker ps -a -q | xargs -I {} docker inspect {} | jq '.[].Name' | grep $WORKSPACE_NAME )" ]; then
    # container does not exist
    docker run -it $PARAMS $DOCKERCLI \
    -v $HOME/work_temp/Code:/home/work/Code \
    -v $HOME/work_temp/secrets:/home/work/secrets \
    -p "8280-8380:8080-8180" \
    pirafrank/workspace:"$VERSION"
else
    # container exists
    if [ -z "$(docker ps -q | xargs -I {} docker inspect {} | jq '.[].Name' | grep $WORKSPACE_NAME)" ]; then
        # container is stopped
        docker start $WORKSPACE_NAME
        sleep 3
    fi
    # container is running
    docker exec -it $WORKSPACE_NAME zsh
fi

