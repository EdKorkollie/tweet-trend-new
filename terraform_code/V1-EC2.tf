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

resource "aws_instance" "demo-server" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  key_name      = "vprofile-prod-key"
}
