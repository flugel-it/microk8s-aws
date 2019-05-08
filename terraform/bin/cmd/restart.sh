#!/bin/bash

set -e

aws ec2 start-instances --instance-ids `cat ./ec2instance`