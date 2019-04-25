#!/bin/bash

set -e

BASE=`realpath \`dirname $0\``

aws ec2 stop-instances --instance-ids `cat $BASE/ec2instance`