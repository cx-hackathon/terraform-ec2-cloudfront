# VPC module

This module will create a VPC associated with subnet, internet gateway and route table

## Input

| Name              | Description                                    | Example      |
| ----------------- | ---------------------------------------------- | ------------ |
| vpc_cidr_block    | private ip address range for vpc               | 10.0.0.0/16  |
| subnet_cidr_block | private ip address range for subnet inside vpc | 10.0.10.0/24 |
| avail_zone        | availability zone of vpc                       | us-east-1    |

For other inputs and outputs, you can refer to [official documentation](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)

## Usage

```
module "<any name you want>" {
  source = "terraform-aws-modules/vpc/aws"

  name = "<name of your vpc>"
  cidr = "<vpc_cidr_block>"

  azs            = ["<avail_zone>"]
  public_subnets = ["<subnet_cidr_block>"]
}
```

For example,

```
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
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
```
