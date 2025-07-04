provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.micro"
  key_name               = "id_rsa"
  associate_public_ip_address = true
  tags = {
    Name = "FinanceMe-Test-Server"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/inventory/test"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/var/lib/jenkins/.ssh/id_rsa")
    host        = self.public_ip
  }
}

output "test_instance_ip" {
  value = aws_instance.app_server.public_ip
}
