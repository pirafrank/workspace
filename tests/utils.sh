#!/bin/bash

# checking for installed utils in userspace

echo ' 🧪🧪🧪 Testing Time! 🧪🧪🧪 '

set -e

checks=(yq yq2 dive lazygit delta ipinfo)
for check in "${checks[@]}"; do
  echo "Checking $check"
  [[ ! -z $( which $check | grep $HOME ) ]] && echo "✅ Test passed" || { echo "❌ Test failed." 1>&2 ; exit 1; }
done
