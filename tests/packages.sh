#!/bin/bash

# checking for installed packages

# Linux support only this time.
# safe fallback
[[ $(uname -s) != 'Linux' ]] && exit 0



echo ' 🧪🧪🧪 Testing Time! 🧪🧪🧪 '

set -e

checks=(curl gpg sudo wget vim zsh tmux mosh rsync less mc tree jq unzip zip atop htop bat fdfind)
for check in "${checks[@]}"; do
  echo "Checking $check"
  [[ $( command -v $check ) ]] && echo "✅ Test passed" || { echo "❌ Test failed." 1>&2 ; exit 1 ; }
done
