#!/bin/bash

set -e

IP_ADDRESS=`./bin/terraform output ip`

echo "Updating kubeconfig"
ssh -i $MICROK8S_AWS_PRIVATE_KEY_FILE ubuntu@$IP_ADDRESS "/snap/bin/microk8s.config -l" | sed -e "s/127.0.0.1/$IP_ADDRESS/g" -e "s/certificate-authority-data: \(.*\)/insecure-skip-tls-verify: true/g" > kubeconfig

echo "Kubeconfig stored in ./kubeconfig file"
echo "kubectl get nodes --kubeconfig=./kubeconfig"