resource "aws_instance" "app_server" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.micro"
  key_name               = "id_rsa"
  associate_public_ip_address = true
  tags = {
    Name = "FinanceMe-Prod-Server"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > /var/lib/jenkins/workspace/FinanceMe/ansible/inventory/prod"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/var/lib/jenkins/.ssh/id_rsa")
    host        = self.public_ip
  }
}
