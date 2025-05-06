#!/bin/bash

set -o nounset
set -o errexit

readonly __DIR__="$( cd "$(dirname "$0")"; pwd )"

(
  cd java
  rake make_jar
)

${__DIR__}/dxjruby.sh "$@"
