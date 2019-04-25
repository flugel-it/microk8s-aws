#!/bin/bash

set -e

BASE=`realpath \`dirname $0\``

cd $BASE/terraform ; $BASE/bin/terraform destroy