variable "ami_filter_name" {
    description = "Filter to use to find the AMI by name"
    default = "flugel-microk8s-aws-*"
}

variable "ami_filter_owner" {
    description = "Filter for the AMI owner"
    default = "self"
}
variable "instance_type" {
    description = "Type of EC2 instance"
    default = "t2.micro"
}

variable "key_pair" {
    description = "Key pair to access the EC2 instance, could be your public ssh key"
}

variable "allow_ssh_from_cidrs_0" {
    description = "CIDRs allowed to connect to SSH"
}
variable "allow_kube_api_from_cidrs_0" {
    description = "CIDRs allowed to access Kubernetes API"
}
variable "allow_ingress_from_cidrs_0" {
    description = "CIDRs allowed to access the cluster Ingress"
}
variable "tag_name" {
    description = "Value of the tags Name to apply to all resources"
    default = "microk8s-aws"
}
