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
  security_groups             = var.sg_ids
  user_data                   = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "app_asg" {
  name                 = "app_asg"
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.lt.name
  vpc_zone_identifier  = var.app_subnet_ids
}

resource "aws_autoscaling_attachment" "app_asga" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  lb_target_group_arn    = var.app_tg_arn
}

resource "aws_autoscaling_group" "web_asg" {
  name                 = "web_asg"
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.lt.name
  vpc_zone_identifier  = var.web_subnet_ids
}

resource "aws_autoscaling_attachment" "web_asga" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  lb_target_group_arn    = var.web_tg_arn
}
