#!/bin/bash

case "${PACKAGE_MANAGER}" in
yum)
  yum install -y wget unzip file
  yum install -y git gcc gcc-c++ cmake make
  yum install -y bzip2 openssl-devel readline-devel zlib-devel
  ;;
apt)
  apt update
  apt install -y wget unzip file
  apt install -y git gcc g++ cmake make
  apt install -y bzip2 libssl-dev libreadline-dev zlib1g-dev
  ;;
*)
  echo "Unsupported PACKAGE_MANAGER: ${PACKAGE_MANAGER}"
  exit 1
  ;;
esac
