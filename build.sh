#!/bin/bash

function checkrun {
  if [ $1 -ne 0 ]; then
    echo $2
    exit 2
  fi
}

function usage {
  echo "
  Usage: $0 [base|workspaces|bundle|all] (OPTIONS)
  "
  exit 1
}

### main script ###

echo "
$0
Tip: You can pass 'docker build' params as first argument.
"

if [ $# -lt 1 ]; then usage; fi

STEP="$1"
PARAMS="$2"

# get versions to build
source workspace_versions.sh

# nb. ;;& operator requires bash 4 
case $STEP in
  base|all)
    # build base image
    docker build $PARAMS -t pirafrank/workspace:latest -f Dockerfile .
    checkrun $? 'Something went wrong...'
    ;;&

  workspaces|all)
    cd workspaces # bc of docker context
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
      -t pirafrank/workspace:rust -f Dockerfile_rust.dockerfile . && \
    docker build $PARAMS --build-arg GOLANGVERSION=${GOLANGVERSION} \
      -t pirafrank/workspace:go${GOLANGVERSION} -f Dockerfile_golang.dockerfile .
    checkrun $? 'Something went wrong...'
    cd ..
    ;;&  

  bundle|all)
    cd workspaces
    docker build $PARAMS \
    --build-arg JAVAVERSION=${JAVAVERSION} \
    --build-arg JAVAVENDOR=${JAVAVENDOR} \
    --build-arg NODEVERSION=${NODEVERSION} \
    --build-arg GOLANGVERSION=${GOLANGVERSION} \
    --build-arg PYTHON3VERSION=${PYTHON3VERSION} \
    --build-arg RUBYVERSION=${RUBYVERSION} \
    -t pirafrank/workspace:bundle \
    -f Dockerfile_bundle.dockerfile .
    checkrun $? 'Something went wrong...'
    cd ..
    ;;

  *) 
    usage
    ;;
esac

# list built images
docker images | grep workspace


