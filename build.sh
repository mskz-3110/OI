#!/bin/bash

source mash.bash

bash ./setup_projects.sh

changed projects
  changed extc
    build_all extc
    
    changed cpp/extc
      build_all cpp/extc
    popd
    
    remaked artifacts
    popd
    
    copy lib artifacts/.
popd
