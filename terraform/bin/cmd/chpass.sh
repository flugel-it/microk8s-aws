#!/bin/bash

set -e

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

IP_ADDRESS=`./bin/terraform output ip`

ask "Choose a password for the Kubernetes cluster admin user" "admin"
ADMIN_PASSWORD=$ANSWER
echo "Changing cluster admin password, this may take some time..."
ssh -i $MICROK8S_AWS_PRIVATE_KEY_FILE ubuntu@$IP_ADDRESS "change-microk8s-password \"$ADMIN_PASSWORD\" > /dev/null"
echo "Updating kubeconfig"
ssh -i $MICROK8S_AWS_PRIVATE_KEY_FILE ubuntu@$IP_ADDRESS "/snap/bin/microk8s.config -l" | sed -e "s/127.0.0.1/$IP_ADDRESS/g" -e "s/certificate-authority-data: \(.*\)/insecure-skip-tls-verify: true/g" > kubeconfig