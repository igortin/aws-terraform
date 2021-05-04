locals {
  ssh_key         = "my-training"
  security_groups = ["sg-3fe69e19"]
}

resource "aws_security_group" "trainning-asg-sg" {

  name = "terraform-asg-sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic ingress {
    for_each = var.ingress

    content {
      protocol    = lookup(ingress.value, "protocol")
      cidr_blocks = lookup(ingress.value, "v4_cidr_blocks")
      from_port   = try(lookup(ingress.value, "from_port"), -1)
      to_port     = try(lookup(ingress.value, "to_port"), -1)
    }
  }
}


resource "aws_security_group" "trainning-elb-sg" {
  name = "terraform-elb-sg"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_elb" "trainning-elb" {
  name            = "trainning-elb"
  subnets         = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.trainning-elb-sg.id]
  # availability_zones = data.aws_availability_zones.available.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.elb_port
    instance_protocol = "http"
  }
}


resource "aws_launch_template" "trainning-launch-template" {
  name_prefix = "trainning-launch-template-"
  image_id             = data.aws_ami.image.id
  instance_type        = "t2.nano"
  iam_instance_profile {
    name = aws_iam_instance_profile.trainning-profile.name
  }
  
  user_data = filebase64("template/cloud-config.sh")
  
  block_device_mappings {
    device_name = "/dev/xda1"
    ebs {
      volume_size = 20
    }
  }
  
  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.trainning-asg-sg.id]
  }

  key_name = local.ssh_key
}

resource "aws_autoscaling_group" "trainning-asg" {
  launch_template {
    id      = aws_launch_template.trainning-launch-template.id
    version = "$Latest"
  }
  # availability_zones   = data.aws_availability_zones.available.names
  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  min_size            = 1
  desired_capacity    = 3
  max_size            = 5

  load_balancers    = [aws_elb.trainning-elb.name]
  health_check_type = "ELB"

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 70
    }
    triggers = ["tag"]
  }


  tag {
    key                 = "Name"
    value               = "trainning-asg"
    propagate_at_launch = true
  }
}