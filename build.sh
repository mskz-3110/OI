#!/bin/bash

bash ./download_mash.sh
MASH=mash.bash
source ${MASH}

bash ./setup_projects.sh

chdir projects
  projects_dir=$PWD
  
  chdir extc
    extc_dir=$PWD
    
    build_all extc
    
    chdir cpp/extc
      build_all cpp/extc
    chdir ${extc_dir}
    
    rmkdir artifacts
    copy lib artifacts/.
  chdir ${projects_dir}
