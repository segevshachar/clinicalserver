resource "aws_security_group" "sg" {
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "3000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3000"
  }

  ingress {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = "3001"
      protocol    = "tcp"
      self        = "false"
      to_port     = "3001"
  }

  ingress {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = "3002"
      protocol    = "tcp"
      self        = "false"
      to_port     = "3002"
  }

  ingress {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = "3003"
      protocol    = "tcp"
      self        = "false"
      to_port     = "3003"
  }

  ingress {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = "3004"
      protocol    = "tcp"
      self        = "false"
      to_port     = "3004"
  }

  ingress {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = "3005"
      protocol    = "tcp"
      self        = "false"
      to_port     = "3005"
  }

  ingress {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = "3006"
      protocol    = "tcp"
      self        = "false"
      to_port     = "3006"
  }


  name   = "${var.environment}-sg"
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.environment}-sg",
    Environment = var.environment,
    Automation  = "Terraform"
  }
}

resource "aws_security_group" "default" {
  description = "default VPC security group"
  vpc_id      = var.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    from_port = "0"
    protocol  = "-1"
    self      = "true"
    to_port   = "0"
  }

  name = "${var.environment}-default-sg"

  tags = {
    Name        = "${var.environment}-sg",
    Environment = var.environment,
    Automation  = "Terraform"
  }
}
