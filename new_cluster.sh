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
PROJECT_DIR="${ANSWER/#\~/$HOME}"

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
ask "What is your internet IP address?" $DEFAULT_INTERNET_IP
INTERNET_IP=$ANSWER
ask "Terraform module source" $DEFAULT_TF_MODULE_SOURCE
TF_MODULE_SOURCE=$ANSWER

echo "Generating project directory"
mkdir -p $PROJECT_DIR
echo "Generating key"
ssh-keygen -m PEM -f $PROJECT_DIR/key.pem
chmod 400 $PROJECT_DIR/key.pem
SSH_KEY_PAIR_FILE=$PROJECT_DIR/key.pem.pub

echo key.pem >> $PROJECT_DIR/.gitignore
echo ec2instance >> $PROJECT_DIR/.gitignore
echo hostname >> $PROJECT_DIR/.gitignore
echo kubeconfig >> $PROJECT_DIR/.gitignore

mkdir -p $PROJECT_DIR/terraform
cp -R $BASE/project_template/* $PROJECT_DIR

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
$BASE/installdep.sh terraform https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip $BASE/bin
cp $BASE/bin/terraform $PROJECT_DIR/bin/terraform
cd $PROJECT_DIR/terraform ; ../bin/terraform init
echo "Project created in: $PROJECT_DIR"
echo "Go to $PROJECT_DIR/terraform and run ./bin/up.sh to create cluster"

#TODO: create gitignore
# generate key