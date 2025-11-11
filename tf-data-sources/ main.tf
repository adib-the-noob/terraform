terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "name" {
  most_recent = true
  owners      = ["amazon"]
}

output "ami_id" {
  value = data.aws_ami.id
}

data "aws_security_group" "name" {
  tags = {
    Name = "MySecurtiyGroup"
  }
}

output "aws_security_group" {
  value = data.aws_security_group.name
}
