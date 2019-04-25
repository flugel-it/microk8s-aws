#!/bin/bash

set -e

BASE=`dirname $0`

cd $BASE ; $BASE/bin/terraform apply

# get/create kubeconf
# create key file 400