provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  key_name                    = "id_rsa"
  associate_public_ip_address = true
  tags = {
    Name = "FinanceMe-Test-Server"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/var/lib/jenkins/.ssh/id_rsa")
    host        = self.public_ip
  }
}

resource "null_resource" "generate_inventory" {
  depends_on = [aws_instance.app_server]

  provisioner "local-exec" {
    command = "echo '[test]\n${aws_instance.app_server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/id_rsa' > /var/lib/jenkins/workspace/FinanceMe/ansible/inventory/test"
  }
}
