#!/bin/bash

set -e

TERRAFORM=./bin/terraform

$TERRAFORM destroy $@

rm kubeconfig