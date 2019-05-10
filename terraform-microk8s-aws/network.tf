resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = "${local.common_tags}"
}

resource "aws_eip" "public-ip" {
  instance = "${aws_instance.cluster.id}"
  vpc      = true

  tags = "${local.common_tags}"
}