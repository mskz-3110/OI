#!/bin/bash

source ./install_packages.sh
source ./install_ruby.sh

if [ -z "${ANDROID_NDK}" ]; then
  if [ -z "${ANDROID_NDK_VERSION}" ]; then
    echo "Not found: ANDROID_NDK_VERSION"
    exit 1
  fi
  
  if [ -z "${ANDROID_NDK_INSTALL_DIR}" ]; then
    export ANDROID_NDK_INSTALL_DIR="/tmp"
  fi
  bash ./download_android_ndk.sh
  export ANDROID_NDK="${ANDROID_NDK_INSTALL_DIR}/android-ndk-${ANDROID_NDK_VERSION}"
fi

build_all(){
  name=$1
  
  case "${name}" in
  *cpp*)
    ANDROID_STL=c++_static PLATFORM=android CONFIG=Debug sh rake build
    ANDROID_STL=c++_static PLATFORM=android CONFIG=Release sh rake build
    
    ANDROID_STL=gnustl_static PLATFORM=android CONFIG=Debug sh rake build
    ANDROID_STL=gnustl_static PLATFORM=android CONFIG=Release sh rake build
    ;;
  *)
    PLATFORM=android CONFIG=Debug sh rake build
    PLATFORM=android CONFIG=Release sh rake build
    ;;
  esac
}

source ./build.sh
