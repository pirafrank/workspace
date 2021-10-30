#!/usr/bin/env zsh

function fail_test { echo "❌ Test failed." 1>&2 ; exit 1 ; }

# checking for installed workspaces resources

echo ' 🧪🧪🧪 Testing Time! 🧪🧪🧪 '

set -e

checks=(go java mvn node python3 rustc ruby)
for check in "${checks[@]}"; do
  echo "Checking $check"
  [[ ! -z $( which $check | grep $HOME ) ]] && echo "✅ Test passed" || fail_test
done

# the ones below are functions, using a different method
checks=(nvm pyenv rvm)
for check in "${checks[@]}"; do
  echo "Checking $check"
  [[ ! -z $( command -v $check ) ]] && echo "✅ Test passed" || fail_test
done
