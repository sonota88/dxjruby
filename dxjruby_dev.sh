#!/usr/bin/env bash

set -o nounset
set -o errexit

readonly __DIR__="$( cd "$(dirname "$0")"; pwd )"

(
  cd ${__DIR__}/java
  rake make_jar
)

${__DIR__}/dxjruby "$@"
