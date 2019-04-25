#!/bin/bash

set -e

BASE=`dirname $0`

cd $BASE ; $BASE/bin/terraform destroy