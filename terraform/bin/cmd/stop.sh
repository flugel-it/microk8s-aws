#!/bin/bash

set -e

aws ec2 stop-instances --instance-ids `cat ./ec2instance`