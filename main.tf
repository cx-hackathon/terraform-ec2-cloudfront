terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "test-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["ap-southeast-1a"]
  public_subnets = ["10.0.10.0/24"]
  public_subnet_tags = {
    Name = "${var.env_prefix}-subnet-1"
  }

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}


module "myapp-server" {
  source          = "./modules/ec2"
  vpc_id          = module.vpc.vpc_id
  allowed_ip      = "0.0.0.0/0"
  image_id        = "ami-078c1149d8ad719a7"
  instance_type   = "t2.micro"
  subnet_id       = module.vpc.public_subnets[0]
  avail_zone      = "ap-southeast-1a"
  env_prefix      = "dev"
}
