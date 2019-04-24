#!/bin/bash

BASE=`dirname $0`
DEFAULT_AMI_NAME_FILTER="flugel-microk8s-aws-*"
DEFAULT_AMI_OWNER_FILTER="self"
DEFAULT_INSTANCE_TYPE="t2.micro"
DEFAULT_SSH_KEY_PAIR_FILE=~/.ssh/id_rsa.pub
DEFAULT_INTERNET_IP=`dig +short myip.opendns.com @resolver1.opendns.com`
DEFAULT_TF_MODULE_SOURCE=`realpath $BASE/terraform`

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

ask "Choose a project directory" ""
PROJECT_DIR=$ANSWER

if [ -e $PROJECT_DIR ]; then
    ask "Project directory already exists, do you want to continue ?" "no"
    if [ $ANSWER == "no" ]; then
        exit 0
    fi
fi

ask "AMI name filter" $DEFAULT_AMI_NAME_FILTER
AMI_NAME_FILTER=$ANSWER
ask "AMI owner filter" $DEFAULT_AMI_OWNER_FILTER
AMI_OWNER_FILTER=$ANSWER
ask "EC2 instance type" $DEFAULT_INSTANCE_TYPE
INSTANCE_TYPE=$ANSWER
ask "SSH key pair file" $DEFAULT_SSH_KEY_PAIR_FILE
SSH_KEY_PAIR_FILE=$ANSWER
ask "What is your internet IP address?" $DEFAULT_INTERNET_IP
INTERNET_IP=$ANSWER
ask "Terraform module source" $DEFAULT_TF_MODULE_SOURCE
TF_MODULE_SOURCE=$ANSWER

echo "Generating project"
mkdir -p $PROJECT_DIR/terraform

cat <<EOF >$PROJECT_DIR/terraform/main.tf
module "microk8s_cluster" {
  source = "$TF_MODULE_SOURCE"
  ami_filter_name = "$AMI_NAME_FILTER"
  ami_filter_owner = "$AMI_OWNER_FILTER"
  instance_type = "$INSTANCE_TYPE"
  allow_ssh_from_cidrs = ["$INTERNET_IP/32"]
  allow_kube_api_from_cidrs = ["$INTERNET_IP/32"]
  allow_ingress_from_cidrs = ["$INTERNET_IP/32"]
  key_pair ="`cat $SSH_KEY_PAIR_FILE`"
}
EOF

echo "Installing terraform binary to the project directory"
mkdir -p $PROJECT_DIR/bin
$BASE/installdep.sh terraform https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip $BASE/tmp
cp $BASE/tmp/terraform $PROJECT_DIR/bin/terraform
$PROJECT_DIR/bin/terraform init $PROJECT_DIR/terraform
echo "Project created in: $PROJECT_DIR"
echo "Go to $PROJECT_DIR/terraform and run `./bin/up.sh` to create cluster"