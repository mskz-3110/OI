#!/bin/bash

source ./install_packages.sh
source ./install_ruby.sh

if [ -z "${ANDROID_NDK_DIR}" ]; then
  ANDROID_NDK_DIR=/tmp
fi

if [ -z "$*" ]; then
  ANDROID_NDK_VERSIONS=(r10e)
else
  ANDROID_NDK_VERSIONS=$*
fi

ANDROID_STLS=(c++_static gnustl_static)
ANDROID_ARCHS=(x86 armeabi-v7a arm64-v8a)
PLATFORMS=(android)
CONFIGS=(Debug Release)

bash ./download_android_ndk.sh ${ANDROID_NDK_VERSIONS}

sh(){
  command="$*"
  echo "${PWD}$ ${command}"
  ${command}
  exit_status=$?
  if [ 0 -ne ${exit_status} ]; then
    exit ${exit_status}
  fi
}

build(){
  android_ndk=$1
  android_stl=$2
  platform=$3
  config=$4
  
  ANDROID_NDK=${android_ndk} ANDROID_STL=${android_stl} PLATFORM=${platform} CONFIG=${config} sh rake build
}

build_extc(){
  if [ ! -d extc ]; then
    sh git clone --depth 1 https://github.com/mskz-3110/extc.git
  fi
  
  check_files=()
  pushd extc
    bundle install
    if [ -f ../../gems/buildrake.gem ]; then
      gem install ../../gems/buildrake.gem
    fi
    
    rake setup
    for android_ndk_version in ${ANDROID_NDK_VERSIONS[@]}; do
      for platform in ${PLATFORMS[@]}; do
        for config in ${CONFIGS[@]}; do
          for android_arch in ${ANDROID_ARCHS[@]}; do
            lib_dir="lib/${platform}/${android_ndk_version}_${config}/libs/${android_arch}"
            rm -fr ${lib_dir}
            
            check_files+=("${PWD}/${lib_dir}/libextc.a")
            check_files+=("${PWD}/${lib_dir}/libextc.so")
          done
          
          build "${ANDROID_NDK_DIR}/android-ndk-${android_ndk_version}" "" ${platform} ${config}
          
          pushd cpp/extc
            for android_stl in ${ANDROID_STLS[@]}; do
              build "${ANDROID_NDK_DIR}/android-ndk-${android_ndk_version}" ${android_stl} ${platform} ${config}
            done
          popd
        done
      done
    done
    
    for check_file in ${check_files[@]}; do
      if [ ! -f "${check_file}" ]; then
        echo "Not found: ${check_file}"
        exit 1
      fi
    done
    
    rm -fr artifacts
    mkdir artifacts
    mv lib artifacts/.
  popd
}

pushd projects
  build_extc
popd
