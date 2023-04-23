provider "aws" {
  region  = "us-west-2"
}

data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "example" {
  count                = var.instance_count
  ami                  = data.aws_ami.example.id
  instance_type        = var.instance_type
  availability_zone    = "us-west-2a"
  security_groups      = ["launch-wizard-2"]
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  tags = {
    Name         = "Webserver${var.environment}"
    Project_code = "123456"
    Environment  = var.environment
  }
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  depends_on = [
    aws_iam_instance_profile.test_profile
  ]
  lifecycle {
    ignore_changes = [
      tags["Project_code"]
    ]
  }
}

resource "aws_iam_role" "test_role" {
  name = "test_role_terraform${var.environment}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Created_date = "04/10/2023"
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile${var.environment}"
  role = aws_iam_role.test_role.name
  depends_on = [
    aws_iam_role.test_role
  ]
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy${var.environment}"
  role = aws_iam_role.test_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  depends_on = [
    aws_iam_role.test_role
  ]
}