#!/bin/bash

if [ ! -f mash.bash ]; then
  curl -sS -H "Cache-Control: no-cache" https://raw.githubusercontent.com/mskz-3110/mash/master/mash.bash -o mash.bash
fi
