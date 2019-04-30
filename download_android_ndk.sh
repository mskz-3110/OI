#!/bin/bash

if [ -z "${ANDROID_NDK_DIR}" ]; then
  ANDROID_NDK_DIR="/tmp"
fi

android_ndk_versions=$*

case "$(uname)" in
Darwin)
  os_type=darwin
  ;;
*)
  os_type=linux
  ;;
esac

if [ ! -d ${ANDROID_NDK_DIR} ]; then
  mkdir -p ${ANDROID_NDK_DIR}
fi

pushd ${ANDROID_NDK_DIR}
  for android_ndk_version in ${android_ndk_versions[@]}; do
    url="https://dl.google.com/android/repository/android-ndk-${android_ndk_version}-${os_type}-x86_64.zip"
    zip_file="$(basename ${url})"
    android_ndk_dir="./android-ndk-${android_ndk_version}"
    if [ ! -f "${android_ndk_dir}/ndk-build" ]; then
      if [ ! -f "${zip_file}" ]; then
        wget ${url} -O ${zip_file}
      fi
      
      unzip -q ${zip_file}
    fi
  done
popd
