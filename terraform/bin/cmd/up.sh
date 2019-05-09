#!/bin/bash

set -e

TERRAFORM=./bin/terraform

ANSWER=""

function ask() {
    echo -n "$1 [$2]: "
    read
    if [ "$REPLY" == "" ]; then
        ANSWER=$2
    else
        ANSWER="$REPLY"
    fi
}

if [ ! -d .terraform ]; then
    $TERRAFORM init
fi

$TERRAFORM apply $@

KUBE_HOST=`$TERRAFORM output ip`
EC2_INSTANCE=`$TERRAFORM output ec2instance`

# Wait for the server
until ssh -i $MICROK8S_AWS_PRIVATE_KEY_FILE -o "StrictHostKeyChecking=no" ubuntu@$KUBE_HOST "/snap/bin/microk8s.status > /dev/null" ; do
    echo "Server not ready yet. Waiting for server"
    sleep 5
done

ssh -i $MICROK8S_AWS_PRIVATE_KEY_FILE ubuntu@$KUBE_HOST "/snap/bin/microk8s.config -l" | sed -e "s/127.0.0.1/$KUBE_HOST/g" -e "s/certificate-authority-data: \(.*\)/insecure-skip-tls-verify: true/g" > kubeconfig

echo "Server is up and running"
echo "The IP address is $KUBE_HOST"
echo "The EC2 InstanceIds is $EC2_INSTANCE"
echo "Kubeconfig stored in ./kubeconfig file"
echo "kubectl get nodes --kubeconfig=./kubeconfig"
echo "You can connect using ssh -i $MICROK8S_AWS_PRIVATE_KEY_FILE ubuntu@$KUBE_HOST"
