#!/bin/bash

set -e

BASE=`realpath \`dirname $0\``

aws ec2 start-instances --instance-ids `cat $BASE/ec2instance`