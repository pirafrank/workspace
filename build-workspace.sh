#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify the image version to build."
    exit 1
fi

PARAMS="$2"

docker build $PARAMS -t pirafrank/workspace:"$1" -f Dockerfile .

