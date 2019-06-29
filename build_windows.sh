#!/bin/bash

if [ -n "${APPVEYOR_BUILD_WORKER_IMAGE}" ]; then
  case "${APPVEYOR_BUILD_WORKER_IMAGE}" in
  "Visual Studio 2017")
    export WINDOWS_VISUAL_STUDIO_VERSION=2017
    ;;
  esac
fi

if [ -z "${WINDOWS_VISUAL_STUDIO_VERSION}" ]; then
  echo "Not found: WINDOWS_VISUAL_STUDIO_VERSION"
  exit 1
fi

build_all(){
  case "${WINDOWS_VISUAL_STUDIO_VERSION}" in
  2012)
    cmake_generator="Visual Studio 11 2012"
    ;;
  2013)
    cmake_generator="Visual Studio 12 2013"
    ;;
  2015)
    cmake_generator="Visual Studio 14 2015"
    ;;
  2017)
    cmake_generator="Visual Studio 15 2017"
    ;;
  *)
    echo "Unsupported: WINDOWS_VISUAL_STUDIO_VERSION ${WINDOWS_VISUAL_STUDIO_VERSION}"
    exit 1
    ;;
  esac
  
  WINDOWS_RUNTIME=MT WINDOWS_ARCH=Win32 CMAKE_GENERATOR="${cmake_generator}" PLATFORM=windows CONFIG=Debug sh rake build
  WINDOWS_RUNTIME=MT WINDOWS_ARCH=x64 CMAKE_GENERATOR="${cmake_generator}" PLATFORM=windows CONFIG=Debug sh rake build
  WINDOWS_RUNTIME=MT WINDOWS_ARCH=Win32 CMAKE_GENERATOR="${cmake_generator}" PLATFORM=windows CONFIG=Release sh rake build
  WINDOWS_RUNTIME=MT WINDOWS_ARCH=x64 CMAKE_GENERATOR="${cmake_generator}" PLATFORM=windows CONFIG=Release sh rake build
  
  WINDOWS_RUNTIME=MD WINDOWS_ARCH=Win32 CMAKE_GENERATOR="${cmake_generator}" PLATFORM=windows CONFIG=Debug sh rake build
  WINDOWS_RUNTIME=MD WINDOWS_ARCH=x64 CMAKE_GENERATOR="${cmake_generator}" PLATFORM=windows CONFIG=Debug sh rake build
  WINDOWS_RUNTIME=MD WINDOWS_ARCH=Win32 CMAKE_GENERATOR="${cmake_generator}" PLATFORM=windows CONFIG=Release sh rake build
  WINDOWS_RUNTIME=MD WINDOWS_ARCH=x64 CMAKE_GENERATOR="${cmake_generator}" PLATFORM=windows CONFIG=Release sh rake build
}

source ./build.sh
