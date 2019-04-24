data "aws_ami" "cluster" {
  most_recent      = true
  owners           = ["${var.ami_filter_owner}"]

  filter {
    name   = "name"
    values = ["${var.ami_filter_name}"]
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