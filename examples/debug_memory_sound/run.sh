#!/usr/bin/env bash

function print_this_dir() {
  if [ -L "$0" ]; then
    dirname "$(readlink "$0")"
  else
    cd "$(dirname "$0")"; pwd
  fi
}
readonly __DIR__="$(print_this_dir)"

readonly DXJRUBY_DIR="$(
  cd $__DIR__
  cd ../../
  pwd
)"

readonly JRUBY_CMD=${DXJRUBY_DIR}/jruby-10.0.2.0/bin/jruby

# --------------------------------

function cmd_bundle() {
  $JRUBY_CMD -S bundle "$@"
}

function cmd_run() {
  # (
  #   cd ${DXJRUBY_DIR}/java
  #   rake make_jar
  # )

  $JRUBY_CMD -S bundle exec \
    $JRUBY_CMD -I ${DXJRUBY_DIR}/lib main.rb
}

# --------------------------------

cmd=
if [ $# -ge 1 ]; then
  cmd="$1"; shift
fi

case $cmd in
  bundle )
    cmd_bundle "$@"
;; * )
     cmd_run
;;
esac
