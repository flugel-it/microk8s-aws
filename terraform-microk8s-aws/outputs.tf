output "ip" {
  value = "${aws_eip.public-ip.public_ip}"
}
output "ec2instance" {
  value = "${aws_instance.cluster.id}"
}