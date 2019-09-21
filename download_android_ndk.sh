#!/bin/bash

source mash.bash

if [ -z "${ANDROID_NDK_INSTALL_DIR}" ]; then
  ANDROID_NDK_INSTALL_DIR="/tmp"
fi

maked ${ANDROID_NDK_INSTALL_DIR}
  url="https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-"
  case "$(uname)" in
  Darwin)
    url="${url}darwin-x86_64.zip"
    ;;
  *)
    url="${url}linux-x86_64.zip"
    ;;
  esac
  
  zip_file="$(basename ${url})"
  android_ndk_dir="./android-ndk-${ANDROID_NDK_VERSION}"
  if [ ! -f "${android_ndk_dir}/ndk-build" ]; then
    if [ ! -f "${zip_file}" ]; then
      sh wget -q ${url} -O ${zip_file}
    fi
    
    sh unzip -q ${zip_file}
  fi
popd
