# microk8s-aws

This project provides an easy way to deploy a Kubernetes single-node cluster using an AWS EC2 instance. The project leverages [microk8s](http://microk8s.io) package to install all the cluster components.

## Using this project

The most common workflow for this project has two steps:

* AMI building: Build the AWS AMI using Packer.
* Cluster provisioning: Create an AWS EC2 instance using the built AMI. This step uses Terraform and some helper shell scripts.

### Installing Dependencies

* bash
* awscli

### Building the AMI

This task build an AMI with microk8s. The default AMI name is `"flugel-microk8s-aws-{{isotime | clean_resource_name}}`.
You can change the prefix ("flugel-microk8s-aws") modifying the variable `AMI_NAME_PREFIX` in the Makefile call.

To build the AMI run:

```console
$ AMI_NAME_PREFIX=my-microk8s-ami make ami
```

### Provisioning a new cluster

The directory `terraform` contains all you need to provision a new cluster after building the AMI.

First install Terraform and any other dependency to the `terraform/bin` directory running:

```console
$ cd terraform
$ ./ctl.sh deps
```

You need to specify the values of these Terraform variables to provision a cluster:

* `ami_filter_name`: Filter to use to find the AMI by name. Must be the same you used as the AMI name prefix (default: "flugel-microk8s-aws-*")
* `ami_filter_owner`: Filter for the AMI owner (default: "self")
* `instance_type`: Type of EC2 instance to use (default: "t2.micro")
* `key_pair`: Public key to authenticate access to the instance using SSH
* `allow_ssh_from_cidrs_0`: Network block allowed to connect using SSH.
* `allow_kube_api_from_cidrs_0`: Network block allowed to connect to the Kubernetes API.
* `allow_ingress_from_cidrs_0`: Network block allowed to connect to ports 80 and 443.
* `tag_name`: Tag value of the tag Name to apply to all resources.

You can create a *tfvars* file to pass the variables values or provide them in environment variables, prefixing the variable names with `TF_`.

Inside the `terraform` directory you can find `wizard.sh`, a script to help you to set the values for all the variables.

Example:
```console
$ cd terraform
$ ./wizard.sh
AMI name filter [flugel-microk8s-aws-*]: 
AMI owner filter [self]: 
EC2 instance type [t2.micro]: 
Tag Name [microk8s-aws]: 
What is your internet IP address? [181.166.95.104]: 
SSH public key file [/home/miguel/.ssh/id_rsa.pub]: 
SSH private key file [/home/miguel/.ssh/id_rsa]: 
To setup your cluster:

1) configure aws-cli
2) Install dependencies

./ctl.sh deps

3) Run

./ctl.sh up

```

The wizard creates a `terraform.auto.tfvars` containing your preferences.

Then inside the terraform directory run `./ctl.sh up` to provision your cluster.

```console
$ ./ctl.sh up
```

Terraform will inform you the actions to be executed, type "yes" if you agree. (Optionally you can use the `./ctl.sh up -auto-approve` to skip interactive approval of changes before applying them)

```console
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

This might take some minutes. There might be messages saying "Server not ready yet. Waiting for server", just wait.

When the script finishes it outputs importan information about how to use the cluster.

```console
The IP address is 3.209.90.166
The EC2 InstanceIds is i-0d88f7a8a4186d1ff
Kubeconfig stored in ./kubeconfig file
kubectl get nodes --kubeconfig=./kubeconfig
You can connect using ssh -i key.pem ubuntu@3.209.90.166
```

For example you can see the status of the node running:

```console
$ kubectl get nodes --kubeconfig=kubeconfig
```

### Stoping the cluster

To stop the cluster, but still be able to restart it later run this inside the terraform directory:

```console
$ ./ctl.sh stop
```

This will free some resources, but not all (Volume and Elastic IP will be preserved).

### Restarting an stopped cluster

To restart a previously stopped cluster, run this inside the terraform directory:

```console
$ ./ctl.sh restart
```

This might take some minutes, after that you will be able to use the cluster.


### Destroy a cluster to free all its resources

You can free all your cluster resources running inside the terraform directory:

```console
$ ./ctl.sh destroy
```

Terraform will inform you the actions to be executed, type "yes" if you agree.  (Optionally you can use the `./ctl.sh destroy -auto-approve` to skip interactive approval of changes before applying them)

```console
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

After this, all the cluster's resources in AWS will no longer exist.

You can still recreate the cluster running `./ctl.sh up`

### Other ctl.sh commands

```
Usage: ./ctl.sh <command> [args].

Available commands:
chpass         Change cluster's password
deps           Install required dependencies, like terraform
destroy        Destroy all cluster's resources
kubeconf       Download the cluster's kubeconf file
up             Provision the cluster
restart        Restart a previously "stopped" cluster
status         Shows information such as cluster IP and InstanceId
stop           Stop the cluster without destroying its resources
```

## Moving the Terraform directory outside the project repository

In some cases it might be useful to move the `terraform` directory to another place or repository. In that case just copy the directory and update the Terraform module source in `terraform/main.tf` to point to this repository.


Example:

```terraform
module "microk8s_cluster" {
  source = "github.com/flugel-it/microk8s-aws//terraform-microk8s-aws"
  ami_filter_name = "${var.ami_filter_name}"
  ami_filter_owner = "${var.ami_filter_owner}"
  instance_type = "${var.instance_type}"
  allow_ssh_from_cidrs = ["${var.allow_ssh_from_cidrs_0}"]
  allow_kube_api_from_cidrs = ["${var.allow_kube_api_from_cidrs_0}"]
  allow_ingress_from_cidrs = ["${var.allow_ingress_from_cidrs_0}"]
  key_pair = "${var.key_pair}"
}
```

Then proceed as previously described.
