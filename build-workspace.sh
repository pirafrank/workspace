#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify the image version to build."
    exit 1
fi

PARAMS="$2"

docker build $PARAMS \
--build-arg GITUSERNAME='Francesco Pira' \
--build-arg GITUSEREMAIL='dev@fpira.com' \
--build-arg NODEVERSION='12' \
-t pirafrank/workspace:"$1" -f Dockerfile .


