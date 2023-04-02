#!/bin/bash

# reading current working dir
CWD="$(pwd)"
cd

echo "Installing Wasmer and WAPM..."
curl https://get.wasmer.io -sSfL | sh

echo "Installing wasmtime..."
curl https://wasmtime.dev/install.sh -sSf | bash

# restoring working dir
cd "$CWD"
