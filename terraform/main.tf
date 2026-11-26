
# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get an available subnet
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Latest Amazon Linux 2023 ARM64 AMI
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

# Security group
resource "aws_security_group" "linux_sg" {
  name        = "${var.environment_name}-sg"
  description = "Security group for Linux EC2"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = (
      var.enable_public_ip &&
      var.ssh_allowed_cidr != ""
    ) ? [1] : []

    content {
      description = "SSH access from approved IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.ssh_allowed_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment_name}-sg"
  }
}

# EC2 instance
resource "aws_instance" "linux_ec2" {
  ami                         = data.aws_ssm_parameter.ami.value
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.linux_sg.id]
  associate_public_ip_address = var.enable_public_ip

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name        = var.environment_name
    Environment = "test"
    ManagedBy   = "Terraform"
  }
}
