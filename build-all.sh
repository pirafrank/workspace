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

# get versions to build
source workspace_versions.sh

# workspaces
docker build $PARAMS --build-arg JAVAVERSION=${JAVAVERSION} --build-arg JAVAVENDOR=${JAVAVENDOR} \
  -t pirafrank/workspace:java${JAVAVERSION}-${JAVAVENDOR} -f Dockerfile_java.dockerfile . && \
docker build $PARAMS --build-arg NODEVERSION=${NODEVERSION} \
  -t pirafrank/workspace:node${NODEVERSION} -f Dockerfile_node.dockerfile . && \
docker build $PARAMS --build-arg PYTHON3VERSION=${PYTHON3VERSION} \
  -t pirafrank/workspace:python${PYTHON3VERSION} -f Dockerfile_python3.dockerfile . && \
docker build $PARAMS --build-arg RUBYVERSION=${RUBYVERSION} \
  -t pirafrank/workspace:ruby${RUBYVERSION} -f Dockerfile_ruby.dockerfile . && \
docker build $PARAMS \
  -t pirafrank/workspace:rust -f Dockerfile_rust.dockerfile .
checkrun $? 'Something went wrong...'

cd ..

# list built images
docker images | grep workspace


