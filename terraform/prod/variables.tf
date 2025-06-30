variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI"
  default     = "ami-0f5ee92e2d63afc18"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  description = "Your AWS EC2 Key Pair name"
  default     = "your-key-name"
}

variable "private_key_path" {
  description = "Path to your .pem key file"
  default     = "~/.ssh/your-key.pem"
}
