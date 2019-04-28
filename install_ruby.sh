#!/bin/bash

if [ -z "${RUBY_VERSION}" ]; then
  RUBY_VERSION=2.4.0
fi

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
eval "$(rbenv init -)"

RUBY_BUILD_CACHE_PATH=/tmp CONFIGURE_OPTS="--disable-install-rdoc" rbenv install ${RUBY_VERSION}
rbenv global ${RUBY_VERSION}
