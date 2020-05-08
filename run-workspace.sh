#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify an image version to run."
    exit 1
fi

PARAMS="$2"

mkdir -p $HOME/work_temp/Code
mkdir -p $HOME/work_temp/secrets

docker run -it --name workspace $PARAMS \
-v $HOME/work_temp/Code:/root/Code \
-v $HOME/work_temp/secrets:/root/secrets \
-p 8100:8080 \
-p 3100:3000 \
pirafrank/workspace:"$1"


