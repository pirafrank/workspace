#!/bin/zsh

if [[ -z "$1" ]]; then
    echo "
Please specify the Java version and JDK vendor.
Supported versions are from 8 to 15.
"
    exit 1
fi

VENDOR="$2"
if [[ -z "$VENDOR" ]]; then
    echo "
You may also specify vendor. Use 'openjdk' (default) or 'adoptopenjdk'.
"
    VENDOR=openjdk
fi

JAVAVERSION="$1"
folder="${HOME}/bin2"

case $VENDOR in
openjdk)
  case $JAVAVERSION in
  8)
    url='https://api.adoptopenjdk.net/v3/binary/latest/8/ga/linux/x64/jdk/hotspot/normal/openjdk?project=jdk'
    ;;
  9)
    url='https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz'
    ;;
  10)
    url='https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz'
    ;;
  11)
    url='https://api.adoptopenjdk.net/v3/binary/latest/11/ga/linux/x64/jdk/hotspot/normal/openjdk?project=jdk'
    ;;
  12)
    url='https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_linux-x64_bin.tar.gz'
    ;;
  13)
    url='https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_linux-x64_bin.tar.gz'
    ;;
  14)
    url='https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_linux-x64_bin.tar.gz'
    ;;
  15)
    url='https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_linux-x64_bin.tar.gz'
    ;;
  *)
    echo "Unsupported version. Exiting..."
    exit 1
  esac
  ;;
adoptopenjdk)
  url="https://api.adoptopenjdk.net/v3/binary/latest/${JAVAVERSION}/ga/linux/x64/jdk/hotspot/normal/adoptopenjdk?project=jdk"
  ;;
*)
  echo "Unsupported vendor. Exiting..."
  exit 1
esac



# creating target dir if it doesn't exist
# it should've been created in prev script
if [ -d $folder ]; then
  mkdir -p $folder
fi
cd $folder

# download java version
echo "
Downloading Java ${JAVAVERSION} by ${VENDOR}
from $url
"
wget -c -O jdk.tar.gz $url
# sometimes url may be broken
if [ $? -ne 0 ]; then
  echo "Something has gone wrong..."
  exit 1
fi

# installing
echo "Installing Java ${JAVAVERSION}..."
tar -xzf jdk.tar.gz
JAVA_DOWNLOADED=$(tar --exclude='./*/*' -ztvf jdk.tar.gz | awk '{print $6}' | cut -d'/' -f1 | uniq | head)
rm -f jdk.tar.gz

# updating symlinks
JAVA_ALIAS=$(printf "jdk${JAVAVERSION}" | cut -d'.' -f1)

if [ -L "$(pwd)/${JAVA_ALIAS}" ]; then rm -f "$(pwd)/${JAVA_ALIAS}"; fi
ln -s "$(pwd)/${JAVA_DOWNLOADED}" "$(pwd)/${JAVA_ALIAS}"

if [ -L "$(pwd)/jdk" ]; then rm -f "$(pwd)/jdk"; fi
ln -s "$(pwd)/${JAVA_ALIAS}" "$(pwd)/jdk"

# adding to env
touch "$HOME/.bashrc"
echo "export PATH=$(pwd)/jdk/bin:\$PATH" >> "$HOME/.bashrc"
echo "export JAVA_HOME=$(pwd)/jdk" >> "$HOME/.bashrc"

