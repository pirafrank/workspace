#!/usr/bin/env bash

function fail_test { echo "❌ Test failed." 1>&2 ; exit 1 ; }

# checking for installed packages

# Linux support only this time.
# safe fallback
[[ $(uname -s) != 'Linux' ]] && exit 0

echo ' 🧪🧪🧪 Testing Time! 🧪🧪🧪 '

set -e

checks=(curl gpg sudo wget vim zsh tmux mosh rsync less mc tree jq unzip zip atop htop batcat fdfind)
for check in "${checks[@]}"; do
  echo "Checking $check"
  [[ $( command -v $check ) ]] && echo "✅ Test passed" || fail_test
done
