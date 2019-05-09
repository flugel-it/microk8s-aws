output "ip" {
  value = "${module.microk8s_cluster.ip}"
}
output "ec2instance" {
  value = "${module.microk8s_cluster.ec2instance}"
}