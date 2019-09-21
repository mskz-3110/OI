#!/bin/bash

source mash.bash

GEMS_DIR=${PWD}/gems

changed projects
  if [ ! -d extc ]; then
    sh git clone https://github.com/mskz-3110/extc.git
  fi
  
  changed extc
    bundle install
    gem install ${GEMS_DIR}/buildrake.gem
    
    rake setup
  popd
popd
