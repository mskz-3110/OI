#!/bin/bash

if [ -f /etc/redhat-release ]; then
  cat /etc/redhat-release
elif [ -f /etc/os-release ]; then
  cat /etc/os-release
fi

gcc -dumpversion
