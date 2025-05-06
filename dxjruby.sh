#!/bin/bash

set -o nounset

readonly __DIR__="$( cd "$(dirname "$0")"; pwd )"
readonly JRUBY_DIR="${__DIR__}/jruby-10.0.0.0"

${JRUBY_DIR}/bin/jruby -I "${__DIR__}/lib" "$@"
