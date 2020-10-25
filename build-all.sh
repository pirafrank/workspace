#!/bin/bash

function checkrun {
  if [ $1 -ne 0 ]; then
    echo $2
    exit 2
  fi
}

echo "
$0
Tip: You can pass 'docker build' params as first argument.
"
PARAMS="$1"

# build base image
docker build $PARAMS -t pirafrank/workspace:latest -f Dockerfile .
checkrun $? 'Something went wrong...'

cd workspaces # bc of docker context

# workspaces
docker build $PARAMS -t pirafrank/workspace:node12 -f Dockerfile_node.dockerfile . && \
docker build $PARAMS -t pirafrank/workspace:python38 -f Dockerfile_python3.dockerfile . && \
docker build $PARAMS -t pirafrank/workspace:ruby26 -f Dockerfile_ruby.dockerfile . && \
docker build $PARAMS -t pirafrank/workspace:rust -f Dockerfile_rust.dockerfile . && \
docker build $PARAMS -t pirafrank/workspace:java11 -f Dockerfile_java.dockerfile .
checkrun $? 'Something went wrong...'

cd ..

# list built images
docker images | grep workspace


