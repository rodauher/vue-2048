terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16"
    }
  }
}

# Configure the AWS Provider

provider "aws" {
  region = var.region
}

#AWS-EC2 instance

resource "aws_instance" "web" {
  count = 4
  instance_type          = var.instance_type
  ami                    = var.ami
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.vpc_security_group_ids]

  tags = {
    name = "Terraforminstance-${count.index}"
  }
}
