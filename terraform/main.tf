module "microk8s_cluster" {
  source = "../terraform-microk8s-aws"
  ami_filter_name = "${var.ami_filter_name}"
  ami_filter_owner = "${var.ami_filter_owner}"
  instance_type = "${var.instance_type}"
  allow_ssh_from_cidrs = ["${var.allow_ssh_from_cidrs_0}"]
  allow_kube_api_from_cidrs = ["${var.allow_kube_api_from_cidrs_0}"]
  allow_ingress_from_cidrs = ["${var.allow_ingress_from_cidrs_0}"]
  key_pair = "${var.key_pair}"
  tag_name = "${var.tag_name}"
}