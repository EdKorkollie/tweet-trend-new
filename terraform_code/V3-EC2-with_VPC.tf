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
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  key_name               = "vprofile-prod-key"
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id              = aws_subnet.dpw-public_subent_01.id
}

#Creating security group
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id      = aws_vpc.dpw-vpc.id


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

#creating vpc
resource "aws_vpc" "dpw-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dpw-vpc"
  }
}

#creating subnet1
resource "aws_subnet" "dpw-public_subent_01" {
  vpc_id                  = aws_vpc.dpw-vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "dpw-public_subent_01"
  }
}

#creating subnet2
resource "aws_subnet" "dpw-public_subent_02" {
  vpc_id                  = aws_vpc.dpw-vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "dpw-public_subent_02"
  }
}

#Creating internet gateway
resource "aws_internet_gateway" "dpw-igw" {
  vpc_id = aws_vpc.dpw-vpc.id
  tags = {
    Name = "dpw-igw"
  }
}

#Creating route table
resource "aws_route_table" "dpw-public-rt" {
  vpc_id = aws_vpc.dpw-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpw-igw.id
  }
  tags = {
    Name = "dpw-public-rt"
  }
}

#Creating route table association 1
resource "aws_route_table_association" "dpw-rta-public-subent-1" {
  subnet_id      = aws_subnet.dpw-public_subent_01.id
  route_table_id = aws_route_table.dpw-public-rt.id
}

#Creating route table association 2
resource "aws_route_table_association" "dpw-rta-public-subent-2" {
  subnet_id      = aws_subnet.dpw-public_subent_02.id
  route_table_id = aws_route_table.dpw-public-rt.id
}




