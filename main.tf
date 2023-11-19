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
  region = "ap-southeast-1"
  alias  = "main"
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

module "vpc" {
  providers = {
    aws = aws.main
  }

  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env_prefix}-vpc"
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

# data "aws_route53_zone" "zone" {
#   name = "grinbean.hk"
# }

module "myapp-server" {
  providers = {
    aws = aws.main
  }

  source          = "./modules/ec2"
  vpc_id          = module.vpc.vpc_id
  allowed_ip      = "0.0.0.0/0"
  image_id        = "ami-078c1149d8ad719a7"
  instance_type   = "t2.micro"
  subnet_id       = module.vpc.public_subnets[0]
  avail_zone      = "ap-southeast-1a"
  env_prefix      = "prod-cathay"
}

module "myapp-cf" {
  providers = {
    aws = aws.virginia
  }

  source = "./modules/cloudfront"
  hostname = module.myapp-server.instance.public_dns
  http_port = 8080
  https_port = 443
  description = "cathay-cf1"
  viewer_protocol_policy = "allow-all"
}

