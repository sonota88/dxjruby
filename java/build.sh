#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

readonly __DIR__="$( cd "$(dirname "$0")"; pwd )"
readonly MVN_CMD=./mvnw
readonly DOCKER_IMG_FULL=dxjruby-build:1

# --------------------------------

function cmd_setup() {
  echo "Build docker image"
  cmd_docker_build

  echo "Install Maven Wrapper"
  cmd_docker_run \
    mvn -N wrapper:wrapper -Dmaven=3.9.9
}

function cmd_make_jar() {
  $MVN_CMD clean package

  echo "----"
  ls -l target/*.jar
}

function cmd_make_jar_container() {
  cmd_docker_run \
    bash build.sh make-jar
}

function cmd_docker_build() {
  docker build \
    --build-arg USER=$USER \
    --build-arg GROUP=$(id -gn) \
    --progress plain \
    -t ${DOCKER_IMG_FULL} .
}

function cmd_docker_run() {
  docker run --rm \
    -v "$(pwd):/home/${USER}/work" \
    -v "$(pwd)/mvn_local_repo:/home/${USER}/.m2" \
    ${DOCKER_IMG_FULL} \
    "$@"
}

# --------------------------------

cd $__DIR__

cmd=
if [ $# -ge 1 ]; then
  cmd="$1"; shift
fi

case "$cmd" in
  setup )
    cmd_setup
;; make-jar )
     cmd_make_jar
;; make-jar-container )
     cmd_make_jar_container
;; docker-build )
     cmd_docker_build
;; docker-run )
     cmd_docker_run "$@"
;; *)
     echo "invalid argument" >&2
     ;;
esac
