#/!bin/bash

set -e

sudo snap alias microk8s.kubectl kubectl
sudo apt-get install -y bash-completion screen vim tcpdump
sudo /snap/bin/kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl
# Adding ingress
sudo microk8s.enable ingress
# Adding storage
sudo microk8s.enable storage
