resource "aws_launch_template" "app" {
  name_prefix   = "simple-tasks-"
  image_id      = data.aws_ami.app.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(file("${path.module}/user-data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "simple-tasks-app" }
  }
}

resource "aws_autoscaling_group" "app" {
  name                = "simple-tasks-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.app.arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "simple-tasks-app"
    propagate_at_launch = true
  }
}
