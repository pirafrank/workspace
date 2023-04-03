#!/usr/bin/env bash

image_name='pirafrank/workspace'

get_available_remote() {
    if ! command -v curl 2>&1 >/dev/null || ! command -v jq 2>&1 >/dev/null ; then
        echo 'Cannot fetch remote versions: scripts needs curl and jq to be installed and in PATH'.
        exit 1
    else
        printf "Pull-able images are:\n"
        avalable=$(curl -s "https://registry.hub.docker.com/v2/repositories/${image_name}/tags/" | jq -r '.results[].name')
        printf "$avalable\n\n"
    fi

}

get_available_local() {
    available="$(docker images | grep "$image_name" | awk '{print $1":"$2}')"
    if [ -z "$available" ]; then
        printf "No available versions locally.\n\n"
    else
        printf "Locally available images are:\n"
        printf "$available\n\n"
    fi
}

if [[ -z "$1" ]]; then
    echo "Please specify an image tag to run."
    echo "You can optionally add parameters to 'docker run' as \$2."
    echo "\$3 is to enable DOCKERCLI socket, optional. It can be anything, just not blank.\n"
    get_available_local
    get_available_remote
    exit 1
fi

IMAGE_TAG="$1"
WORKSPACE_NAME="workspace-${IMAGE_TAG}"
PARAMS="$2"

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
    pirafrank/workspace:"$IMAGE_TAG"
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

