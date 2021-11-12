output "PIP" {
    value = aws_instance.web.public_ip
}

output "ami" {
    value = data.aws_ami.centos.id
}