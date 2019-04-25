#!/bin/bash

set -e

BASE=`realpath \`dirname $0\``

cd $BASE/terraform ; $BASE/bin/terraform apply

cd $BASE/terraform ; $BASE/bin/terraform state show module.microk8s_cluster.aws_eip.public-ip | grep public_dns | awk '{print $3}' > $BASE/hostname
cd $BASE/terraform ; $BASE/bin/terraform state show module.microk8s_cluster.aws_instance.cluster | grep "^id " | awk '{print $3}' > $BASE/ec2instance

# get kubeconfig
KUBE_HOST=`cat $BASE/hostname`

# Wait for the server
until ssh -i $BASE/key.pem -o "StrictHostKeyChecking=no" ubuntu@$KUBE_HOST "/snap/bin/microk8s.status"; do
    echo "Server not ready yet. Waiting for server"
    sleep 5
done

ssh -i $BASE/key.pem -o "StrictHostKeyChecking=no" ubuntu@$KUBE_HOST "/snap/bin/microk8s.config -l" | sed -e "s/127.0.0.1/$KUBE_HOST/g" -e "s/certificate-authority-data: \(.*\)/insecure-skip-tls-verify: true/g" > $BASE/kubeconfig

echo "Server is up and running"
echo "The hostname is $KUBE_HOST"
echo "Kubeconfig stored in ./kubeconfig file"
echo "You can connect using ssh -i key.pem ubuntu@$KUBE_HOST"
