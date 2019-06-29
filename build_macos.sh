#!/bin/bash

build_all(){
  PLATFORM=macos CONFIG=Debug sh rake build
  PLATFORM=macos CONFIG=Release sh rake build
}

source ./build.sh
