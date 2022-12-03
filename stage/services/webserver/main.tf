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

resource "aws_launch_configuration" "launch_config_1" {
  image_id        = "ami-0d5bf08bc8017c83b"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance_grouper.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello there, big guy" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "group_1" {
  launch_configuration = aws_launch_configuration.launch_config_1.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.targetron.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 5

  tag {
    key                 = "Name"
    value               = "terraformed-asg-segment"
    propagate_at_launch = true

  }
}

resource "aws_security_group" "instance_grouper" {
  name = var.security_group_name

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "balancio" {
  name               = var.alb_name
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.albie.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.balancio.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 my dude"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "albie" {
  name = "terraform_alb_sg"
  # the following lifecycle rule is vital to tf on aws; check out the registry
  lifecycle {
    create_before_destroy = true
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "targetron" {
  lifecycle {
    create_before_destroy = true
  }
  name = var.alb_name

  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "big_earsky" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetron.arn
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

variable "jacks_security_group_name" {
  description = "Group name for instance(s)"
  type        = string
  default     = "basic_group"
}

variable "server_port" {
  description = "Port number used for HTTP requests"
  type        = number
  default     = 8088
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
  default     = "albie-the-dragon"
}

variable "security_group_name" {
  description = "The name of the good ol group"
  type        = string
  default     = "one_abnormal_group"
}

output "port_address" {
  description = "descriptions are good for your teammates"
  value       = var.server_port
}

output "alb_dns_name" {
  value       = aws_lb.balancio.dns_name
  description = "ol LB's domain, my dude"
}