resource "aws_instance" "web" {
    ami = data.aws_ami.centos.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sec_group_for_nagios.id]
    key_name               = aws_key_pair.key_pair_for_nagios.key_name
}

resource "null_resource" "nagios_installation" {
  depends_on = [aws_instance.web, aws_security_group.sec_group_for_nagios]
  triggers = {
    always_run = timestamp()
  }

  provisioner "remote-exec" {
    connection {
      host        = aws_instance.web.public_ip
      type        = "ssh"
      user        = "centos"
      private_key = file("~/.ssh/id_rsa")
    }
    inline = [
        "cd /tmp",
        "sudo yum install wget -y",
        "wget https://assets.nagios.com/downloads/nagiosxi/xi-latest.tar.gz",
        "tar xzf xi-latest.tar.gz",
        "cd nagiosxi",
        "yes | sudo ./fullinstall",
    ]
  }
}