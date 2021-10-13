#!/bin/bash

folder="${HOME}/bin2"

# creating target dir if it doesn't exist
# it should've been created in prev script
if [ -d $folder ]; then
  mkdir -p $folder
fi
cd $folder

# installing maven
echo "Downloading latest maven"
url=$(curl https://maven.apache.org/download.cgi | \
  grep -oE '"https:(.*?).tar.gz"' | grep binaries | tr -d '"')
echo $url
wget -c -O mvn.tar.gz $url
# sometimes url may be broken
if [ $? -ne 0 ]; then
  echo "Something has gone wrong..."
  exit 1
fi
echo "Installing latest maven version"
tar -xzf mvn.tar.gz
MVN_DOWNLOADED=$(tar --exclude='./*/*' -ztvf mvn.tar.gz | awk '{print $6}' | cut -d'/' -f1 | uniq | head)
rm -f mvn.tar.gz

# updating symlink
if [ -L "$(pwd)/maven" ]; then
  echo "Replacing existing maven version..."
  rm -f "$(pwd)/maven"
else
  echo "No maven install detected in target dir ($folder)"
fi
ln -s "$(pwd)/${MVN_DOWNLOADED}" "$(pwd)/maven"

# adding to env
touch "$HOME/.bashrc"
echo "export PATH=$(pwd)/maven/bin:\$PATH" >> "$HOME/.bashrc"

echo "$MVN_DOWNLOADED has been installed.
Remember to source your env."

