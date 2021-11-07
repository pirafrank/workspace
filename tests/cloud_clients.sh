#!/usr/bin/env zsh

function fail_test { echo "❌ Test failed." 1>&2 ; exit 1 ; }

# checking for installed cloud utils in userspace

echo ' 🧪🧪🧪 Testing Time! 🧪🧪🧪 '

set -e

checks=(packer scw hcloud kubectl helm kubectx kubens stern)
for check in "${checks[@]}"; do
  echo "Checking $check"
  [[ ! -z $( which $check | grep $HOME ) ]] && echo "✅ Test passed" || fail_test
done

# checking krew
# krew is installed as a kubectl subcommand
echo "Checking krew"
[[ $( kubectl krew --help | head -n1 | grep kubectl ) ]] && echo "✅ Test passed" || fail_test
