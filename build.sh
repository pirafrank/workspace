#!/bin/bash

function checkrun {
  if [ $1 -ne 0 ]; then
    echo $2
    exit 2
  fi
}

function usage {
  echo "
  Usage: $0 [base|workspaces|bundle|all|golang|java|node|python|ruby|rust] (OPTIONS)
  "
  exit 1
}

function build_base {
    docker build $PARAMS -t pirafrank/workspace:latest -f Dockerfile .
    checkrun $? 'Something went wrong...'
}

function build_bundle {
    cd workspaces  # bc of docker context
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
}

function build_golang {
    docker build $PARAMS --build-arg GOLANGVERSION=${GOLANGVERSION} \
      -t pirafrank/workspace:go${GOLANGVERSION} -f Dockerfile_golang.dockerfile .
    checkrun $? 'Something went wrong...'
}

function build_java {
    docker build $PARAMS --build-arg JAVAVERSION=${JAVAVERSION} --build-arg JAVAVENDOR=${JAVAVENDOR} \
      -t pirafrank/workspace:java${JAVAVERSION}-${JAVAVENDOR} -f Dockerfile_java.dockerfile .
    checkrun $? 'Something went wrong...'
}

function build_node {
    docker build $PARAMS --build-arg NODEVERSION=${NODEVERSION} \
      -t pirafrank/workspace:node${NODEVERSION} -f Dockerfile_node.dockerfile .
    checkrun $? 'Something went wrong...'
}

function build_python {
    docker build $PARAMS --build-arg PYTHON3VERSION=${PYTHON3VERSION} \
      -t pirafrank/workspace:python${PYTHON3VERSION} -f Dockerfile_python3.dockerfile .
    checkrun $? 'Something went wrong...'
}

function build_ruby {
    docker build $PARAMS --build-arg RUBYVERSION=${RUBYVERSION} \
      -t pirafrank/workspace:ruby${RUBYVERSION} -f Dockerfile_ruby.dockerfile .
    checkrun $? 'Something went wrong...'
}

function build_rust {
    docker build $PARAMS \
      -t pirafrank/workspace:rust -f Dockerfile_rust.dockerfile .
    checkrun $? 'Something went wrong...'
}

function build_workspaces {
    cd workspaces  # bc of docker context
    build_golang
    build_java
    build_node
    build_python
    build_ruby
    build_rust
    cd ..
}

function build_alpine {
    docker build $PARAMS -t pirafrank/workspace:alpine -f Dockerfile-alpine.dockerfile .
    checkrun $? 'Something went wrong...'
}

### main script ###

echo "
$0
Tip: You can pass 'docker build' params as second argument.
"

if [ $# -lt 1 ]; then usage; fi

STEP="$1"
PARAMS="$2"

# get versions to build
source workspace_versions.sh

# nb. ;;& operator requires bash 4
case $STEP in
  base)
    # build base image
    build_base
    ;;

  workspaces)
    build_workspaces
    ;;

  bundle)
    build_bundle
    ;;

  bb)
    build_base
    build_bundle
    ;;

  alpine)
    build_alpine
    ;;

  all)
    build_base
    build_bundle
    build_workspaces
    ;;

  *)
    # it's a single workspace...
    cd workspaces  # bc of docker context
    case $STEP in
    golang)
      build_golang
      ;;
    java)
      build_java
      ;;
    node)
      build_node
      ;;
    python3)
      build_python
      ;;
    ruby)
      build_ruby
      ;;
    rust)
      build_rust
      ;;
    *)
      # unknown param
      usage
      ;;
    esac
    cd
esac

# list built images
docker images | grep workspace


