resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "microk8s"
  }
}

resource "aws_eip" "public-ip" {
  instance = "${aws_instance.cluster.id}"
  vpc      = true

  tags {
    Name = "microk8s"
  }
}