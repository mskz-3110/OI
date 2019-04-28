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

build(){
  windows_visual_studio_version=$1
  windows_runtime=$2
  windows_arch=$3
  cmake_generator=$4
  config=$5
  
  WINDOWS_VISUAL_STUDIO_VERSION="${windows_visual_studio_version}" WINDOWS_RUNTIME=${windows_runtime} WINDOWS_ARCH=${windows_arch} CMAKE_GENERATOR="${cmake_generator}" PLATFORM=windows CONFIG=${config} rake build
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
            lib_dir="lib/windows/${windows_visual_studio_version}_${windows_runtime}_${windows_arch}_${config}"
            rm -fr ${lib_dir}
            
            build "${windows_visual_studio_version}" ${windows_runtime} ${windows_arch} "${cmake_generator}" ${config}
            check_files+=("${PWD}/${lib_dir}/extc.lib")
            check_files+=("${PWD}/${lib_dir}/extc.dll")
            
            pushd cpp/extc
              build "${windows_visual_studio_version}" ${windows_runtime} ${windows_arch} "${cmake_generator}" ${config}
            popd
          done
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
