resource "aws_key_pair" "key_pair_for_nagios" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")
}