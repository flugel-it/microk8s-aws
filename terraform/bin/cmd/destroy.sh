#!/bin/bash

set -e

TERRAFORM=./bin/terraform

$TERRAFORM destroy $@

rm hostname kubeconfig ec2instance