provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "app_server" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  associate_public_ip_address = true
  tags = {
    Name = "FinanceMe-Test-Server"
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > /var/lib/jenkins/workspace/FinanceMe/ansible/inventory/test"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.private_key_path)
    host  = self.public_ip
  }
}
