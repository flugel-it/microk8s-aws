resource "aws_instance" "cluster" {
  ami             = "${data.aws_ami.cluster.id}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.sg.id}"]
  subnet_id       = "${aws_subnet.subnet-uno.id}"
  key_name = "${aws_key_pair.user-key.key_name}"

  tags = {
    Name = "microk8s"
  }
}