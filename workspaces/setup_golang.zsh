#!/bin/zsh

GOLANGVERSION="$1"
if [[ -z "$GOLANGVERSION" ]]; then
    echo "
You may also specify a specific (minor) version,
the most recent patch version will be installed.

Now latest version will be installed.
"
    GOLANGVERSION=latest
fi
folder="${HOME}/bin2"

mkdir -p $folder
cd $folder

baseurl='https://golang.org'
if [[ $GOLANGVERSION == 'latest' ]]; then
  # on the website are order by release date
  dlversion="$(curl -sSL https://golang.org/dl/ \
  | grep 'linux-amd64.tar.gz' \
  | grep -oE '[0-9]{1,2}\.[0-9]{1,3}(\.[0-9]{1,3})?' -o \
  | uniq | head -n1)"
else
  # latest patch for given minor version
  dlversion="$(curl -sSL https://golang.org/dl/ \
  | grep 'linux-amd64.tar.gz' \
  | grep "${GOLANGVERSION}" \
  | grep -oE '[0-9]{1,2}\.[0-9]{1,3}(\.[0-9]{1,3})?' -o \
  | uniq | head -n1)"
fi
url="${baseurl}/dl/go${dlversion}.linux-amd64.tar.gz"

echo "
Downloading Go ${dlversion}
from $url
"
wget -c -O go_setup.tar.gz $url
# check download
if [ $? -ne 0 ]; then
  echo "Something has gone wrong..."
  exit 1
fi

# installing
echo "Installing Go ${dlversion}..."
tar -xzf go_setup.tar.gz
rm -f go_setup.tar.gz

# adding to env
echo "export PATH=$(pwd)/go/bin:\$PATH" >> "$HOME/.zsh_custom"
echo "export GOPATH=\$HOME/.golang" >> "$HOME/.zsh_custom"
echo "export PATH=\$HOME/.golang/bin:\$PATH" >> "$HOME/.zsh_custom"
