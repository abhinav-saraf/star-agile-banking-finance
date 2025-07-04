
resource "aws_instance" "app_server" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  key_name                    = "id_rsa"
  associate_public_ip_address = true

  tags = {
    Name = "FinanceMe-Prod-Server"
  }

 provisioner "local-exec" {
  command = <<EOT
    echo "[prod]
    ${self.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/id_rsa ansible_ssh_common_args='-o StrictHostKeyChecking=no'" > /var/lib/jenkins/workspace/FinanceMe/ansible/inventory/prod
  EOT
}

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/var/lib/jenkins/.ssh/id_rsa")
    host        = self.public_ip
  }
}

output "prod_instance_ip" {
  value = aws_instance.app_server.public_ip
}
