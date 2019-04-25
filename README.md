# microk8s-aws

This project provides an easy way to deploy a Kubernetes single-node cluster using an AWS EC2 instance. The project leverages [microk8s](http://microk8s.io) package to install all the cluster components.


## Installing Dependencies

* bash
* awscli
* ssh and ssh-keygen

## Building the AMI

```console
$ make build_deps
$ aws configure
$ make ami
```

## Creating a new cluster

You can use the `new_cluster.sh` wizard to create a new directory containing all the necessary files to manage a Kubernetes cluster.

The wizard asks some questions:

* project directory: A non existing directory where to create the cluster configuration and provisioning scripts.
* AMI name filter: Used to find the right AWS AMI. If you used this project default Makefile to build the AMI, leave the default value here.
* AMI owner filter: The owner of the AMI. If you built the AMI with your own account, leave the default "self".
* EC2 instance type: The instance type to use for your single-node cluster.
* Terraform module source: The source of the Terraform module used to provision the cluster. Use the default to use the module from your computer or enter any other valid location, like a git repository.

The wizard will automatically generate a new key pair, this key pair is used to connect to the instance using SSH.

```console
$ ./new_cluster.sh

Choose a project directory []: ~/example-cluster
AMI name filter [flugel-microk8s-aws-*]: 
AMI owner filter [self]: 
EC2 instance type [t2.micro]: 
What is your internet IP address? [YOUR INTERNET IP]: 
Terraform module source [MICROK8S_AWS_DIR/terraform]: 
Generating project directory
Generating key
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/miguel/example-cluster/key.pem.
Your public key has been saved in /home/miguel/example-cluster/key.pem.pub.
The key fingerprint is:
SHA256:kpnSGcAywPO4Ij5bcx7AxKIgYwKxa3eIWDbFweDVrSE miguel@lxsam1
The key's randomart image is:
+---[RSA 2048]----+
|=o.==o .         |
|.=+oE.o .        |
|*oO= ..o         |
|B*=o...*         |
|+o.=..B S        |
|+.. o. .         |
|+  o o           |
| o. + .          |
| .o  .           |
+----[SHA256]-----+
Installing terraform binary to the project directory
```

After the wizard finishes, go to the cluster project directory you previously entered.

```console
$ cd ~/example-cluster
$ ls
bin  destroy.sh  key.pem  key.pem.pub  start.sh  stop.sh  terraform  up.sh
```

This directory contains various scripts to easily manage the cluster. You can inspect the configuration in `terraform/main.tf`

Run `up.sh` to provision the cluster.
```console
$ ./up.sh
```

Terraform will inform you the actions to be executed, type "yes" if you agree.

```console
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

This might take some minutes. There might be messages saying "Server not ready yet. Waiting for server", just wait.

Then the script will ask you to change the cluster admin password and apply the change.

When the script finishes it outputs importan information about how to use the cluster.

```console
The hostname is ec2-3-214-234-139.compute-1.amazonaws.com
Kubeconfig stored in ./kubeconfig file
You can connect using ssh -i key.pem ubuntu@ec2-3-214-234-139.compute-1.amazonaws.com
```

For example you can see the status of the node running:

```console
$ kubectl get nodes --kubeconfig=kubeconfig
```

## Stoping the cluster

To stop the cluster, but still be able to restart it later run:

```console
$ ./stop.sh
```

This will free some resources, but not all (Volume and Elastic IP will be preserved).

## Restarting an stopped cluster

To restart a previously stopped cluster, run:

```console
$ ./restart.sh
```

This might take some minutes, after that you will be able to use the cluster.


## Destroy a cluster to free all its resources

You can free all your cluster resources running:

```console
$ ./destroy.sh
```

Terraform will inform you the actions to be executed, type "yes" if you agree.

```console
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

After this, all the cluster resources in AWS will no longer exist.

You can still recreate the cluster with `up.sh`