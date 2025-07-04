resource "aws_instance" "app_server" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  key_name                    = "id_rsa"
  associate_public_ip_address = true

  tags = {
    Name = "FinanceMe-Test-Server"
  }

  provisioner "local-exec" {
    command = "echo '[test]' > var/lib/jenkins/workspace/FinanceMe/ansible/inventory/test && echo '${self.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=var/lib/jenkins/.ssh/id_rsa ansible_ssh_common_args=\"-o StrictHostKeyChecking=no\"' >> var/lib/jenkins/workspace/FinanceMe/ansible/inventory/test"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/var/lib/jenkins/.ssh/id_rsa")
    host        = self.public_ip
  }
}
