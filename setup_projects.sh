#!/bin/bash

MASH=mash.bash
source ${MASH}

GEMS_DIR=$PWD/gems

chdir projects
  projects_dir=$PWD
  
  if [ ! -d extc ]; then
    sh git clone https://github.com/mskz-3110/extc.git
  fi
  
  chdir extc
    bundle install
    if [ -f ${GEMS_DIR}/buildrake.gem ]; then
      gem install ${GEMS_DIR}/buildrake.gem
    fi
    
    rake setup
