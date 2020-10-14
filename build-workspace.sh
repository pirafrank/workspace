#!/bin/bash

if [[ -z "$1" || -z "$2" ]]; then
    echo "Please specify the image version to build and Dockerfile name."
    echo "Usage: ./${0} '1.0.0-base' Dockerfile"
    echo "Usage: ./${0} '1.0.0-node12' Dockerfile_node12.dockerfile"
    exit 1
fi

PARAMS="$3"

docker build $PARAMS -t pirafrank/workspace:"$1" -f "$2" .

