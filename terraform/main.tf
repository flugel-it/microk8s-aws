provider "aws" {
}

resource "aws_key_pair" "user" {
  key_name   = "user-key"
  public_key = ""
}

//network.tf
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

//subnets.tf
resource "aws_subnet" "subnet-uno" {
  cidr_block = "${cidrsubnet(aws_vpc.vpc.cidr_block, 3, 1)}"
  vpc_id     = "${aws_vpc.vpc.id}"

  tags {
    Name = "microk8s"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "microk8s"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-uno.id}"
  route_table_id = "${aws_route_table.route-table.id}"
}

//gateways.tf
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "microk8s"
  }
}

//security.tf
resource "aws_security_group" "sg" {
  name_prefix = "microk8s-sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    cidr_blocks = [
      "181.166.95.104/32",
    ]

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "181.166.95.104/32",
    ]

    from_port = 16443
    to_port   = 16443
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

// Cluster instance
data "aws_ami" "cluster" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["flugel-microk8s-aws-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "cluster" {
  ami             = "${data.aws_ami.cluster.id}"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.sg.id}"]
  subnet_id       = "${aws_subnet.subnet-uno.id}"

  tags = {
    Name = "microk8s"
  }
}
