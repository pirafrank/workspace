#!/bin/bash

# checking for installed cloud utils in userspace

echo ' 🧪🧪🧪 Testing Time! 🧪🧪🧪 '

set -e

checks=(packer scw hcloud kubectl helm kubectx kubens stern)
for check in $checks; do
  echo "Checking $check"
  [[ ! -z $( which $check | grep $HOME ) ]] && echo "✅ Test passed" || echo "❌ Test failed." 1>&2
done

# checking krew
# krew is installed as a kubectl subcommand
[[ $( kubectl krew --help | head -n1 | grep kubectl ) ]] && echo "✅ Test passed" || echo "❌ Test failed." 1>&2
