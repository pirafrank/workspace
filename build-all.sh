#!/bin/bash

function checkrun {
  if [ $1 -ne 0 ]; then
    echo $2
    exit 2
  fi
}

PARAMS="$1"

docker build $PARAMS -t pirafrank/workspace:latest -f Dockerfile .
checkrun $? 'Something went wrong...'

cd workspaces # bc of docker context

# workspaces
docker build $PARAMS -t pirafrank/workspace:node12 -f Dockerfile_node12.dockerfile . && \
docker build $PARAMS -t pirafrank/workspace:python38 -f Dockerfile_python38.dockerfile . && \
docker build $PARAMS -t pirafrank/workspace:ruby26 -f Dockerfile_ruby26.dockerfile . && \
docker build $PARAMS -t pirafrank/workspace:rust -f Dockerfile_rust_latest.dockerfile . && \
docker build $PARAMS -t pirafrank/workspace:java11 -f Dockerfile_java11.dockerfile .
checkrun $? 'Something went wrong...'

cd ..

# list built images
docker images | grep workspace


