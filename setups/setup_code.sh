#!/usr/bin/env bash

mkdir -p "$HOME/vscode"
cd "$HOME/vscode" || exit 1
curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli.tar.gz
tar -xf vscode_cli.tar.gz