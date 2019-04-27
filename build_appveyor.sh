#!/bin/bash

platform=$1
shift

configuration=$1
shift

echo "APPVEYOR_BUILD_WORKER_IMAGE=${APPVEYOR_BUILD_WORKER_IMAGE} platform=${platform} configuration=${configuration}"
case "${APPVEYOR_BUILD_WORKER_IMAGE}" in
"Visual Studio 2013")
  echo 2012 2013
  ;;
"Visual Studio 2015")
  echo 2015
  ;;
"Visual Studio 2017")
  echo 2017
  ;;
esac

ruby -v

build_extc(){
  if [ ! -d extc ]; then
    git clone --depth 1 https://github.com/mskz-3110/extc.git
  fi
  
  pushd extc
    bundle install
    if [ -f ../../gems/buildrake.gem ]; then
      gem install ../../gems/buildrake.gem
    fi
    
    rake setup
    rake build windows debug
#    rake build windows release
  popd
}

pushd projects
  build_extc
popd
