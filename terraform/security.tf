resource "aws_security_group" "sg" {
  name_prefix = "microk8s-sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    cidr_blocks = "${var.allow_ssh_from_cidrs}"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = "${var.allow_kube_api_from_cidrs}"

    from_port = 16443
    to_port   = 16443
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = "${var.allow_ingress_from_cidrs}"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = "${var.allow_ingress_from_cidrs}"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "microk8s"
  }
}