#!/bin/zsh

function calculate_url {
  curl -sSL $baseurl | \
    grep 'linux-x64_bin.tar.gz' | head -n1 | \
    grep -E "data-file[=0-9a-zA-Z'//\.%-_]*" -o | \
    cut -d"'" -f2 | cut -d'/' -f3- | \
    sed s@/otn/@/otn-pub/@g | sed s@^@https://@g
}

if [[ -z "$1" ]]; then
    echo "Please specify the Java version."
    echo "Supported version are from 9 to 15."
    exit 1
fi

JAVAVERSION="$1"
folder="${HOME}/bin2"

case $JAVAVERSION in
9)
  url='https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz'
  ;;
10)
  url='https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz'
  ;;
11)
  baseurl='https://www.oracle.com/java/technologies/javase-jdk11-downloads.html'
  url=$(calculate_url $baseurl)
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
  baseurl='https://www.oracle.com/java/technologies/javase-jdk15-downloads.html'
  url=$(calculate_url $baseurl)
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
echo "Downloading Java ${JAVAVERSION}
from $url"
wget -c --no-cookies --no-check-certificate \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" -O jdk.tar.gz $url
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

# updating symlink
if [ -L "$(pwd)/jdk" ]; then rm -f "$(pwd)/jdk"; fi
ln -s "$(pwd)/${JAVA_DOWNLOADED}" "$(pwd)/jdk"

# adding to env
echo "export PATH=$(pwd)/jdk/bin:\$PATH" >> "$HOME/.zsh_custom"
echo "export JAVA_HOME=$(pwd)/jdk" >> "$HOME/.zsh_custom"
