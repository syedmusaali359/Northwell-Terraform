resource "aws_lb" "aws_northwell_alb" {
  name                       = "${var.prefix}-${var.env}-Alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.sg_id]
  subnets                    = var.public_subnet_id[*]
  enable_deletion_protection = false
  tags = {
    Name = "${var.prefix}-${var.env}-Alb"
  }
}

resource "aws_lb_listener" "aws_northwell_alb_listener" {
  load_balancer_arn = aws_lb.aws_northwell_alb.arn
  port              = var.alb.port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.northwell_targetgroup.arn
  }
}
resource "aws_lb_target_group" "northwell_targetgroup" {
  name        = "${var.prefix}-${var.env}-Alb-TG"
  target_type = "ip"
  port        = var.alb.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    enabled             = var.alb.enabled
    interval            = var.alb.interval
    path                = var.alb.path
    timeout             = var.alb.timeout
    matcher             = var.alb.matcher
    healthy_threshold   = var.alb.healthy_threshold
    unhealthy_threshold = var.alb.unhealthy_threshold
  }

  lifecycle {
    create_before_destroy = true
  }
}
