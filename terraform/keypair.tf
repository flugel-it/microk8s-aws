resource "aws_key_pair" "user-key" {
  key_name   = "user-key"
  public_key = "${var.key_pair}"
}