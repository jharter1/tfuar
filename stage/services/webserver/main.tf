terraform {
  required_version = ">=1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "webserver_1" {
  ami                    = "ami-0d5bf08bc8017c83b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance_grouper.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello there, big guy" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true

  tags = {
    "Name" = "minor_server"
  }
}

resource "aws_security_group" "instance_grouper" {
  name = var.security_group_name

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "security_group_name" {
  description = "Group name for instance(s)"
  type        = string
  default     = "basic_group"
}

output "end_location" {

  value       = aws_instance.webserver_1.public_ip
  description = "public IP of said instance"
}