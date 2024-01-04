terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

resource "aws_launch_configuration" "lt" {
  name_prefix                 = "groom_lt"
  image_id                    = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  security_groups = [
    aws_security_group.my_security_group.id
  ]
  user_data = <<-EOF
    #!/bin/bash
    
    EOF

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "asg" {
  name                 = var.asg_name
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.lt.name
}
