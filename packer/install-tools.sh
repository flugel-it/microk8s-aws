#/!bin/bash

set -e

sudo snap install --classic --channel=1.14/stable kubectl
sudo apt-get install bash-completion screen vim tcpdump
/snap/bin/kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl
