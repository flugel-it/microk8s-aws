#/!bin/bash

set -e

sudo apt-get install snapd
sudo snap remove kubectl-eks
sudo snap install --classic --channel=1.15/stable microk8s
sudo microk8s.start
# Wait for microk8s to start
until /snap/bin/microk8s.status ; do sleep 1 ; done
# Enable standard modules
sudo microk8s.enable dns

change-microk8s-password mytestcluster
