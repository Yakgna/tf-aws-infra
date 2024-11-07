resource "aws_autoscaling_group" "csye6225_asg" {
  name                = "csye6225-asg"
  desired_capacity    = 3
  max_size            = 5
  min_size            = 3
  target_group_arns   = [aws_lb_target_group.app_target_group.arn]
  vpc_zone_identifier = aws_subnet.public[*].id
  default_cooldown    = 60

  launch_template {
    id      = aws_launch_template.web_app_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "webapp-asg-instance"
    propagate_at_launch = true
  }
}

# Scale Up Policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up_on_cpu"
  autoscaling_group_name = aws_autoscaling_group.csye6225_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
  policy_type            = "SimpleScaling"
}

# Scale Down Policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down_on_cpu"
  autoscaling_group_name = aws_autoscaling_group.csye6225_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
  policy_type            = "SimpleScaling"
}

# CloudWatch Alarm for Scale Up policy
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "5"
  alarm_description   = "Scale up when CPU > 5%"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.csye6225_asg.name
  }
}

# CloudWatch Alarm for Scale Down policy
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-utilization-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "3"
  alarm_description   = "Scale down when CPU < 3%"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.csye6225_asg.name
  }
}