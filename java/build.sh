#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

readonly __DIR__="$( cd "$(dirname "$0")"; pwd )"
readonly MVN_CMD=./mvnw

# --------------------------------

cmd_setup(){
  echo "Install Maven Wrapper"
  mvn -N wrapper:wrapper -Dmaven=3.9.9
}

cmd_make_jar() {
  $MVN_CMD clean
  $MVN_CMD package -Dmaven.test.skip=true

  echo "----"
  ls -l target/*.jar
}

# --------------------------------

cd $__DIR__

case "$1" in
  setup)
    cmd_setup
;; make-jar)
     cmd_make_jar
;; *)
     echo "invalid argument" >&2
     ;;
esac
