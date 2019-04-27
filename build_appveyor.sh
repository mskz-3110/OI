#!/bin/bash

case "${APPVEYOR_BUILD_WORKER_IMAGE}" in
"Visual Studio 2013")
  WINDOWS_VISUAL_STUDIO_VERSIONS=(2012 2013)
  ;;
"Visual Studio 2015")
  WINDOWS_VISUAL_STUDIO_VERSIONS=(2015)
  ;;
"Visual Studio 2017")
  WINDOWS_VISUAL_STUDIO_VERSIONS=(2017)
  ;;
*)
  WINDOWS_VISUAL_STUDIO_VERSIONS=()
  ;;
esac

WINDOWS_RUNTIMES=(MT MD)
WINDOWS_ARCHS=(Win32 x64)
CONFIGS=(Debug Release)

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
    for windows_visual_studio_version in ${WINDOWS_VISUAL_STUDIO_VERSIONS[@]}; do
      for windows_runtime in ${WINDOWS_RUNTIMES[@]}; do
        for windows_arch in ${WINDOWS_ARCHS[@]}; do
          case "${windows_visual_studio_version}" in
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
          esac
          for config in ${CONFIGS[@]}; do
            echo "[${windows_visual_studio_version} ${windows_runtime} ${windows_arch} ${config}] ${cmake_generator}"
            WINDOWS_VISUAL_STUDIO_VERSION=${windows_visual_studio_version} WINDOWS_RUNTIME=${windows_runtime} WINDOWS_ARCH=${windows_arch} CMAKE_GENERATOR="${cmake_generator}" PLATFORM=windows CONFIG=${config} rake build
          done
        done
      done
    done
  popd
}

pushd projects
  build_extc
popd

wait
