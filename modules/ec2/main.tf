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

resource "tls_private_key" "key-gen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "ssh-key" {
  key_name   = "${var.env_prefix}-key"
  public_key = tls_private_key.key-gen.public_key_openssh
}

resource "local_file" "save-key" {
  content  = tls_private_key.key-gen.private_key_pem
  filename = "${var.env_prefix}-key.pem"
  file_permission = "0400"
}

resource "aws_instance" "myapp-server" {
  ami           = var.image_id
  instance_type = var.instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone      = var.avail_zone

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name

  user_data = file("entry-script.sh")

  tags = {
    Name = "${var.env_prefix}-server"
  }
}

