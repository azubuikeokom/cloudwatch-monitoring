resource "aws_lb" "main" {
  name               = "${var.name}-alb-${var.environment}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [for subnet in data.aws_subnet.all-subnets: subnet.id]

  enable_deletion_protection = false
  tags = {
    Environment = var.environment
  }
}

resource "aws_alb_target_group" "main" {
  name        = "${var.name}-tg-${var.environment}"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc-id
  target_type = "ip"
  depends_on = [
    aws_lb.main,
  ]
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 9090
  protocol          = "HTTP"

    default_action {
     type = "forward"
     target_group_arn = aws_alb_target_group.main.arn

    }
}