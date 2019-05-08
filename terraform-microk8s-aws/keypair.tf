resource "aws_key_pair" "user-key" {
  public_key = "${var.key_pair}"
}