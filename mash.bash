#!/bin/bash

exit_assert(){
  exit_status=$1
  if [ 0 -ne ${exit_status} ]; then
    shift
    echo "$@"
    exit ${exit_status}
  fi
}

execute(){
  "$@"
}

sh(){
  caption="[${PWD}] $@"
  echo "${caption}"
  execute "$@"
  exit_assert $? "Failed($?): ${caption}"
}

remove(){
  sh rm -fr "$@"
}

rename(){
  sh mv "$@"
}

copy(){
  sh cp -r "$@"
}

changed(){
  path=$1
  if [ -d "${path}" ]; then
    pushd ${path}
  else
    exit_assert 1 "Not found: ${path}"
  fi
}

maked(){
  path=$1
  if [ ! -d "${path}" ]; then
    sh mkdir -p ${path}
  fi
  changed ${path}
}

remaked(){
  path=$1
  remove ${path}
  maked ${path}
}

if [[ ! "$-" =~ \i ]]; then
  "$@"
  exit_assert $? "Failed($?): [${PWD}] $@"
fi
