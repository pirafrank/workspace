#!/usr/bin/env zsh

function fail_test { echo "❌ Test failed." 1>&2 ; exit 1 ; }

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# checking for installed workspaces resources

echo ' 🧪🧪🧪 Testing Time! 🧪🧪🧪 '

set -e

echo "Checking nvm"
[[ ! -z $( nvm --version ) ]] && echo "✅ Test passed" || fail_test
echo "Setting nvm default before node test"
source "$SCRIPT_DIR/../workspace_versions.sh"
nvm alias default $NODEVERSION
nvm use default

echo "Checking pyenv"
[[ ! -z $( pyenv --version ) ]] && echo "✅ Test passed" || fail_test

echo "Checking rvm"
[[ ! -z $( rvm --version ) ]] && echo "✅ Test passed" || fail_test

checks=(go java mvn node python3 rustc ruby)
for check in "${checks[@]}"; do
  echo "Checking $check"
  [[ ! -z $( which $check | grep $HOME ) ]] && echo "✅ Test passed" || fail_test
done
