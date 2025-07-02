provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "app_server" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  associate_public_ip_address =true
  tags= {
    Name = "FinanceMe-Prod-Server"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../asible/inventory/prod"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.private_key_path)
    host = self.public_ip
  }
}
