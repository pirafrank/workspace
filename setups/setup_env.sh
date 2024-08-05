#!/bin/bash

### variables ###

export BIN2_PATH="${BIN2_PATH:-${HOME}/bin2}"
folder="$BIN2_PATH"

### functions ###

function del {
  if [ -f "$1" ]; then rm -f "$1"; fi
}

function setArchAndPlatform {
  PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"
  ARCH=$(uname -m)
  case $ARCH in
    armv5*) ARCH_ALT="armv5";;
    armv6*) ARCH_ALT="armv6";;
    armv7*) ARCH_ALT="arm";;
    aarch64) ARCH_ALT="arm64";;
    x86) ARCH_ALT="386";;
    x86_64) ARCH_ALT="amd64";;
    i686) ARCH_ALT="386";;
    i386) ARCH_ALT="386";;
  esac
}

function downloadAndInstall {
  url="$1"
  name="$2"
  if [ -n "$url" ]; then
    del "${BIN2_PATH}/${name}"
    cd /tmp || exit 1
    if [ -n "$(echo "$url" | grep 'tar.gz')" ]; then
      # it's tar.gzipped
      curl -L "$url" | tar xz
    elif [ -n "$(echo "$url" | grep 'zip')" ]; then
      # it's zipped
      curl -o "$name.zip" -L "$url"
      unzip "$name.zip"
      rm -f "$name.zip"
    else
      # not compressed
      curl -o ./"$name" -L "$url"
    fi
    chmod +x "$name"
    mv "${name}" "${BIN2_PATH}/${name}"
    cd - || exit 1
  else
    echo "Unsupported OS. Skipping $name installation..."
  fi
}

function welcome {
  echo "
  Running as : $(whoami)
  Home folder: $HOME
  Install dir: $folder
  Platform   : $PLATFORM
  Arch       : $ARCH (aka ${ARCH_ALT})
  "
}

function createDir {
  folder="$1"
  # creating target dir if it doesn't exist
  # it should've been created in prev script
  if [ ! -d "$folder" ]; then mkdir -p "$folder"; fi
}

function init {
  echo "BIN2_PATH=${BIN2_PATH}"
  setArchAndPlatform
  welcome
  createDir "${BIN2_PATH}"
  cd "${BIN2_PATH}" || exit 1
}
