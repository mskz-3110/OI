#!/bin/bash

if [ -f /etc/redhat-release ]; then
  yum install -y git gcc gcc-c++ cmake make
  yum install -y bzip2 openssl-devel readline-devel zlib-devel
elif [ -f /etc/issue ]; then
  apt update
  apt install -y wget
  apt install -y git gcc g++ cmake make
  apt install -y bzip2 libssl-dev libreadline-dev zlib1g-dev
fi
