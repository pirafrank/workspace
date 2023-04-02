#!/bin/bash

# check mandatory argument
if [[ -z "$1" ]]; then
    echo "
Please specify the Java version and JDK vendor [ openjdk|adoptopenjdk|azul ].
Supported OpenJDK versions are from 8 to 16, Linux on x86_64 only.
macOS on aarch64 is supported only by azul as vendor.
"
    exit 1
fi

# load platform details
PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH=$(uname -m)
# setting platform pairs
case $PLATFORM in
  linux)  PLATFORM_ALT="linux" ; PLATFORM_ALT2="linux" ;;
  darwin) PLATFORM_ALT="mac"   ; PLATFORM_ALT2="macos" ;;
  *) echo "Unsupported platform" ; exit 3 ;;
esac
case $ARCH in
  arm32)   ARCH_ALT="arm32"   ; ARCH_ALT2="arm"; HW_BITS="32" ;;
  aarch64) ARCH_ALT="aarch64" ; ARCH_ALT2="arm"; HW_BITS="64" ;;
  x86_64)  ARCH_ALT="x64"     ; ARCH_ALT2="x86"; HW_BITS="64" ;;
  *) echo "Unsupported arch"; exit 4 ;;
esac

# only azul supports aarch64 on macos
if [ $PLATFORM = 'darwin' ] && [ $ARCH = 'aarch64' ]; then
  printf "\n\nYou're running macOS on Apple Silicon, selecting 'azul' as vendor\n\n\n"
  VENDOR=azul;
fi

# check optional argument
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
openjdk|adoptopenjdk|adoptium|temurin)
  # API supported platforms: linux|mac
  # API supported arch: x64|aarch64
  url="https://api.adoptopenjdk.net/v3/binary/latest/${JAVAVERSION}/ga/${PLATFORM_ALT}/${ARCH_ALT}/jdk/hotspot/normal/adoptopenjdk?project=jdk"
  ;;
azul)
  # supported platforms by API: linux|macos
  # API supported arch: x86|arm
  metaurl="https://api.azul.com/zulu/download/community/v1.0/bundles/latest/?java_version=${JAVAVERSION}&os=${PLATFORM_ALT2}&arch=${ARCH_ALT2}&hw_bitness=${HW_BITS}&ext=tar.gz&bundle_type=jdk"
  url=$(curl -sSL "$metaurl" | jq -r '.url')
  ;;
amazon|corretto)
  url="https://corretto.aws/downloads/latest/amazon-corretto-${JAVAVERSION}-${ARCH_ALT}-${PLATFORM_ALT2}-jdk.tar.gz"
  ;;
*)
  echo "Unsupported vendor. Exiting..."
  exit 1
esac



# creating target dir if it doesn't exist
# it should've been created in prev script
if [ ! -d $folder ]; then
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

