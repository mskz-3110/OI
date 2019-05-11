#!/bin/bash

if [ -n "${RUBY_VERSION}" ]; then
  if [ ! -d ~/.rbenv ]; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  else
    pushd ~/.rbenv
      git pull origin master
    popd
  fi
  
  export PATH="$HOME/.rbenv/bin:$PATH"
  
  if [ ! -d  ~/.rbenv/plugins/ruby-build ]; then
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  else
    pushd ~/.rbenv/plugins/ruby-build
      git pull origin master
    popd
  fi
  
  eval "$(rbenv init -)"
  
  RUBY_BUILD_CACHE_PATH=/tmp CONFIGURE_OPTS="--disable-install-rdoc" rbenv install ${RUBY_VERSION}
  rbenv global ${RUBY_VERSION}
elif [ -d ~/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi
