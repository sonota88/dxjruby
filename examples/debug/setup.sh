#!/usr/bin/env bash

set -o nounset

function print_this_dir() {
  if [ -L "$0" ]; then
    dirname "$(readlink "$0")"
  else
    cd "$(dirname "$0")"; pwd
  fi
}

readonly __DIR__="$(print_this_dir)"

readonly DXJRUBY_DIR="$(
  cd ${__DIR__}/../../
  pwd
)"

readonly JRUBY_VER="$(${DXJRUBY_DIR}/dxjruby jruby-version)"
readonly JRUBY_CMD="${DXJRUBY_DIR}/jruby-${JRUBY_VER}/bin/jruby"

cd $__DIR__

$JRUBY_CMD setup.rb

# export RBENV_ROOT=${HOME}/.anyenv/envs/rbenv
# eval "$(rbenv init - --no-rehash bash)"
# rbenv shell 3.3.10
# ruby setup.rb

# aplay s1.wav
# aplay bgm_2ch.wav
