# Application Load Balancer
resource "aws_lb" "csye6225_lb" {
  name               = "csye6225-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [for subnet in aws_subnet.public[*] : subnet.id]
  idle_timeout       = 300
  tags = {
    Name = "csye6225-lb"
  }
}

# Target Group for the Load Balancer
resource "aws_lb_target_group" "app_target_group" {
  name        = "csye6225-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.csye6225_vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/healthz"
    port                = var.app_port
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  # Allow time for in-flight requests to complete
  deregistration_delay = 300

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }
}

# Load Balancer Listener
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.csye6225_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}
