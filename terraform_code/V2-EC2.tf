provider "aws" {
  region  = "us-east-1"
  profile = "terraform-user"
}

#store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "edward-devops-2023-terraform-remote-state"
    key     = "terraform.tfstate.terraformproject"
    region  = "us-east-1"
    profile = "terraform-user"
  }
}

#creating EC2 instance
resource "aws_instance" "demo-server" {
  ami             = "ami-08a52ddb321b32a8c"
  instance_type   = "t2.micro"
  key_name        = "vprofile-prod-key"
  security_groups = ["demo-sg"]
}

#Creating security group
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"


  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-port"
  }
}
