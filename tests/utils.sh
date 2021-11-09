#!/usr/bin/env zsh

function fail_test { echo "❌ Test failed." 1>&2 ; exit 1 ; }

# checking for installed utils in userspace

echo ' 🧪🧪🧪 Testing Time! 🧪🧪🧪 '

set -e

checks=(yq yq2 dive lazygit delta ipinfo)
for check in "${checks[@]}"; do
  echo "Checking $check"
  [[ ! -z $( which $check | grep $HOME ) ]] && echo "✅ Test passed" || fail_test
done
