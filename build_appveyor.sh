#!/bin/bash

platform=$1
shift

configuration=$1
shift

echo "APPVEYOR_BUILD_WORKER_IMAGE=${APPVEYOR_BUILD_WORKER_IMAGE} platform=${platform} configuration=${configuration}"
case "${APPVEYOR_BUILD_WORKER_IMAGE}" in
Visual Studio 2013)
  
  ;;
Visual Studio 2015)
  
  ;;
Visual Studio 2017)
  
  ;;
esac

ruby -v
gem -v
