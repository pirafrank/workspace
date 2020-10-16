#!/bin/zsh

if [[ -z "$1" ]]; then
    echo "Please specify the image version to build."
    exit 1
fi

JAVAVERSION="$1"
folder="${HOME}/bin2"

case $JAVAVERSION in
11)
  url='https://download.oracle.com/otn-pub/java/jdk/11.0.8%2B10/dc5cf74f97104e8eac863698146a7ac3/jdk-11.0.8_linux-x64_bin.tar.gz'
  ;;
*)
  echo "Unsupported version. Exiting..."
  exit 1
esac

# creating target dir if it doesn't exist
# it should've been created in prev script
if [ -d $folder ]; then
  mkdir -p $folder
fi
cd $folder

# download java version
echo "Downloading Java ${JAVAVERSION}..."
wget -c --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" -O jdk.tar.gz $url

# installing
echo "Installing Java ${JAVAVERSION}..."
tar -xzf jdk.tar.gz
JAVA_DOWNLOADED=$(tar --exclude='./*/*' -ztvf jdk.tar.gz | awk '{print $6}' | cut -d'/' -f1 | uniq | head)
rm -f jdk.tar.gz

# updating symlink
if [ -L "$(pwd)/jdk" ]; then rm -f "$(pwd)/jdk"; fi
ln -s "$(pwd)/${JAVA_DOWNLOADED}" "$(pwd)/jdk"

# adding to env
echo "export PATH=$(pwd)/jdk/bin:\$PATH" >> "$HOME/.zsh_custom"
echo "export JAVA_HOME=$(pwd)/jdk" >> "$HOME/.zsh_custom"
