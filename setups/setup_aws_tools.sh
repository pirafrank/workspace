#!/bin/bash

# this script installs aws tools
# it can also be used to update them to their latest version.

###
### init environment
###

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/setup_env.sh"
init

###
### install aws cli
###

# check if supported platform
if [ ${PLATFORM} != 'linux' ]; then
  echo "Sorry, unsupported platform"
  exit 1
fi

# download for the right arch
cdir="${BIN2_PATH}/tmp"
rm -rf "${cdir}"
mkdir -p "${cdir}"
cd "${cdir}"
curl "https://awscli.amazonaws.com/awscli-exe-${PLATFORM}-${ARCH}.zip" -o "awscliv2.zip"
unzip ./awscliv2.zip

# create install dir if it does not exists
if [ -d "${BIN2_PATH}/aws-cli" ]; then
  UPDATE_FLAG='--update'
else
  # add --update flag if a version is already installed
  mkdir -p "${BIN2_PATH}/aws-cli"
  UPDATE_FLAG=""
fi
./aws/install -i "${BIN2_PATH}/aws-cli" -b "${BIN2_PATH}" $UPDATE_FLAG

# cleanup
rm -rf "${cdir}"

# check installation
if [[ ! -z $(aws --version) ]]; then
  printf "\n\nSUCCESS: aws-cli has been installed correctly\n\n"
else
  printf "\n\nERROR: something went wrong while installing aws-cli\n\n"
fi

###
### install eksctl
###

downloadAndInstall "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_${PLATFORM}_${ARCH_ALT}.tar.gz" eksctl

if [[ ! -z $(eksctl version) ]]; then
  printf "\n\nSUCCESS: eksctl has been installed correctly\n\n"
else
  printf "\n\nERROR: something went wrong while installing eksctl\n\n"
fi
