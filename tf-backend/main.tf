terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
  backend "s3" {
    bucket = "adib-bucket-da780050d2c52f28"
    key    = "backend.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my-servers" {
  ami           = "ami-06fa3f12191aa3337"
  instance_type = "t3.nano"
  tags = {
    Name = "SampleServer"
  }
}
