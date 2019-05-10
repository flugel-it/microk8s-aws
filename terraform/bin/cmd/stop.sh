#!/bin/bash

set -e

EC2_INSTANCE=`./bin/terraform output ec2instance`
aws ec2 stop-instances --instance-ids $EC2_INSTANCE
./bin/terraform destroy -target module.microk8s_cluster.aws_eip.public-ip -auto-approve