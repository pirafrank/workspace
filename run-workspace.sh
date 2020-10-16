#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify an image version to run."
    echo "You can optionally add parameters to 'docker run' as \$2."
    echo "\$3 is to enable DOCKERCLI socket, optional. It can be anything, just not blank."
    exit 1
fi

PARAMS="$2"

# if $3 is present, add value to DOCKERCLI
DOCKERCLI="" && [[ $3 != "" ]] && DOCKERCLI="-v /var/run/docker.sock:/var/run/docker.sock"

mkdir -p $HOME/work_temp/Code
mkdir -p $HOME/work_temp/secrets

docker run -it --name workspace $PARAMS $DOCKERCLI \
-v $HOME/work_temp/Code:/root/Code \
-v $HOME/work_temp/secrets:/root/secrets \
-p 8100:8080 \
-p 3100:3000 \
pirafrank/workspace:"$1"


