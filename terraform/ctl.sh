#!/bin/bash

set -e

BASE=`realpath \`dirname $0\``
CMD=$1

shift
cd $BASE ; ./bin/cmd/$CMD.sh $@