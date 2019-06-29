#!/bin/bash

build_all(){
  PLATFORM=ios CONFIG=Debug sh rake build
  PLATFORM=ios CONFIG=Release sh rake build
}

source ./build.sh
