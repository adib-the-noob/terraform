terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "my-servers" {
  ami           = "ami-06fa3f12191aa3337"
  instance_type = "t3.nano"
  tags = {
    Name = "SampleServer"
  }
}
