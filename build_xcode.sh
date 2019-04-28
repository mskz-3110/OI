#!/bin/bash

PLATFORMS=(macos ios)
CONFIGS=(Debug Release)

get_platform_version(){
  platform=$1
  
  case "${platform}" in
  macos)
    xcrun --sdk macosx --show-sdk-version
    ;;
  ios)
    xcrun --sdk iphoneos --show-sdk-version
    ;;
  esac
}

build(){
  platform=$1
  config=$2
  
  PLATFORM=${platform} CONFIG=${config} rake build
  exit_status=$?
  if [ 0 -ne ${exit_status} ]; then
    exit 1
  fi
}

build_extc(){
  if [ ! -d extc ]; then
    git clone --depth 1 https://github.com/mskz-3110/extc.git
    exit_status=$?
    if [ 0 -ne ${exit_status} ]; then
      exit 1
    fi
  fi
  
  check_files=()
  pushd extc
    bundle install
    if [ -f ../../gems/buildrake.gem ]; then
      gem install ../../gems/buildrake.gem
    fi
    
    rake setup
    for platform in ${PLATFORMS[@]}; do
      for config in ${CONFIGS[@]}; do
        lib_dir="lib/${platform}/$(get_platform_version ${platform})_${config}"
        rm -fr ${lib_dir}
        
        build ${platform} ${config}
        check_files+=("${PWD}/${lib_dir}/libextc.a")
        check_files+=("${PWD}/${lib_dir}/libextc.dylib")
        
        pushd cpp/extc
          build ${platform} ${config}
        popd
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
