#!/bin/bash

set -e

IP_ADDRESS=`./bin/terraform output ip`
EC2_INSTANCE=`./bin/terraform output ec2instance`

echo "IP address: $IP_ADDRESS"
echo "EC2 InstanceId: $EC2_INSTANCE"