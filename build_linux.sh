#!/bin/bash

if [ -f /etc/redhat-release ]; then
  cat /etc/redhat-release
  
  yum install -y git gcc gcc-c++ cmake make
  yum install -y bzip2 openssl-devel readline-devel zlib-devel
elif [ -f /etc/os-release ]; then
  cat /etc/os-release
  
  
fi

source ./install_ruby.sh

PLATFORMS=(linux)
CONFIGS=(Debug Release)

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
        lib_dir="lib/${platform}/linux_${config}"
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
