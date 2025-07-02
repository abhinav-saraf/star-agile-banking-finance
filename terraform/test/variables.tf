variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu Server 24.04 LTS (HVM)"
  default     = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  description = "Your AWS EC2 Key Pair name"
  default     = "id_rsa"
}

variable "private_key_path" {
  description = "Path to your .pem key file"
  default     = "/var/lib/jenkins/.ssh/id_rsa"
}
