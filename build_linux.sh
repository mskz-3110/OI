#!/bin/bash

if [ -f /etc/redhat-release ]; then
  yum install -y git gcc gcc-c++ cmake make
  yum install -y bzip2 openssl-devel readline-devel zlib-devel
elif [ -f /etc/issue ]; then
  apt update
  apt install -y wget
  apt install -y git gcc g++ cmake make
  apt install -y bzip2 libssl-dev libreadline-dev zlib1g-dev
fi

source ./install_ruby.sh

PLATFORMS=(linux)
CONFIGS=(Debug Release)

linux_name(){
  # TODO
  echo ""
}

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
  platform=$1
  config=$2
  
  PLATFORM=${platform} CONFIG=${config} sh rake build
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
    for platform in ${PLATFORMS[@]}; do
      for config in ${CONFIGS[@]}; do
        lib_dir="lib/${platform}/$(linux_name)_${config}"
        rm -fr ${lib_dir}
        
        build ${platform} ${config}
        check_files+=("${PWD}/${lib_dir}/libextc.a")
        check_files+=("${PWD}/${lib_dir}/libextc.so")
        
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
