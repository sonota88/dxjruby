#!/bin/bash

set -o nounset
set -o errexit

readonly __DIR__="$( cd "$(dirname "$0")"; pwd )"
readonly JRUBY_VER=10.0.0.0

cd $__DIR__

wget https://repo1.maven.org/maven2/org/jruby/jruby-dist/${JRUBY_VER}/jruby-dist-${JRUBY_VER}-bin.tar.gz

tar xzf jruby-dist-${JRUBY_VER}-bin.tar.gz 
