#!/bin/bash

function checkrun {
  if [ $1 -ne 0 ]; then
    echo $2
    exit 2
  fi
}

./build-workspace.sh latest Dockerfile
checkrun $? 'Something went wrong...'

./build-workspace.sh node12 workspaces/Dockerfile_node12.dockerfile && \
./build-workspace.sh python38 workspaces/Dockerfile_python38.dockerfile && \
./build-workspace.sh ruby26 workspaces/Dockerfile_ruby26.dockerfile && \
./build-workspace.sh rust workspaces/Dockerfile_rust_latest.dockerfile
checkrun $? 'Something went wrong...'

cd workspaces # bc of docker context
../build-workspace.sh rust-slim Dockerfile_rust_latest_slim.dockerfile && \
../build-workspace.sh ruby26-slim Dockerfile_ruby26_slim.dockerfile
checkrun $? 'Something went wrong...'
cd ..

docker images | grep workspace


