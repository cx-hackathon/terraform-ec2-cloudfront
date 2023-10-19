# EC2 module

This module will create a EC2 instance associated with a security group

## Default settings

Security group

- Inbound rule allow port 22, 5001-5003
  - port 22: set `allowed_ip` below to control the access
  - port 5001-5003: allow all access
- Outbound rule allow all access

You can change the default settings in `modules/ec2/main.tf`

```
resource "aws_security_group" "myapp-sg" {
  name   = "${var.env_prefix}-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  ingress {
    description = "Browser"
    from_port   = 5001
    to_port     = 5003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}
```

## Input

| Name          | Description                                        | Example               |
| ------------- | -------------------------------------------------- | --------------------- |
| vpc_id        | associated vpc id                                  | vpc-1989727f          |
| allowed_ip    | allowed ip address to ssh into ec2 instance        | 0.0.0.0/0             |
| image_id      | AMI id to create instance                          | ami-0df7a207adb9748c7 |
| instance_type | ec2 instance type                                  | t2-micro              |
| subnet_id     | associated subnet id                               | subnet-06a2394f       |
| avail_zone    | availability zone of AWS                           | us-east-1             |
| env_prefix    | environment prefix such as `prod`, `dev` and `uat` | prod                  |

## Output

| Name     | Description                                                 | Example        |
| -------- | ----------------------------------------------------------- | -------------- |
| instance | the whole object containing all info about the ec2 instance | N/A (Too long) |

## Usage

```
module "<any name you want>" {
  source          = "./modules/ec2"
  vpc_id          = "<vpc_id>"
  allowed_ip      = "<allowed_ip>"
  image_id        = "<image_id>"
  instance_type   = "<instance_type>"
  subnet_id       = "<subnet_id>"
  avail_zone      = "<avail_zone>"
  env_prefix      = "<env_prefix>"
}
```

For example,

```
module "myapp-server" {
  source          = "./modules/ec2"
  vpc_id          = module.vpc.vpc_id
  allowed_ip      = "0.0.0.0/0"
  image_id        = "ami-0df7a207adb9748c7"
  instance_type   = "t2.micro"
  subnet_id       = module.vpc.public_subnets[0]
  avail_zone      = "ap-southeast-1a"
  env_prefix      = "dev"
}
```
