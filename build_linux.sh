#!/bin/bash

source ./install_packages.sh
source ./install_ruby.sh

build_all(){
  PLATFORM=linux CONFIG=Debug sh rake build
  PLATFORM=linux CONFIG=Release sh rake build
}

source ./build.sh
