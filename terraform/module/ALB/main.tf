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
    # type             = "forward"
    # target_group_arn = aws_lb_target_group.northwell_targetgroup.arn
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_target_group" "northwell_targetgroup" {
  name        = "${var.prefix}-${var.env}-Nginx-TG"
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

resource "aws_lb_listener_rule" "nginx_host_based_routing" {
  listener_arn = aws_lb_listener.aws_northwell_alb_listener.arn
  priority     = 1

  condition {
    host_header {
      values = ["nginx-northwell.stickball.biz"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.northwell_targetgroup.arn
  }
}


resource "aws_lb_target_group" "northwell_admin_targetgroup" {
  name        = "${var.prefix}-${var.env}-Admin-TG"
  target_type = "ip"
  port        = var.alb.admin_port
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

resource "aws_lb_listener_rule" "admin_host_based_routing" {
  listener_arn = aws_lb_listener.aws_northwell_alb_listener.arn
  priority     = 2

  condition {
    host_header {
      values = ["manage-northwell.stickball.biz"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.northwell_admin_targetgroup.arn
  }
}

resource "aws_lb_target_group" "northwell_server_targetgroup" {
  name        = "${var.prefix}-${var.env}-Server-TG"
  target_type = "ip"
  port        = var.alb.server_port
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
resource "aws_lb_listener_rule" "server_host_based_routing" {
  listener_arn = aws_lb_listener.aws_northwell_alb_listener.arn
  priority     = 3

  condition {
    host_header {
      values = ["api-northwell.stickball.biz"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.northwell_server_targetgroup.arn
  }
}

resource "aws_lb_target_group" "northwell_client_targetgroup" {
  name        = "${var.prefix}-${var.env}-Client-TG"
  target_type = "ip"
  port        = var.alb.client_port
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
resource "aws_lb_listener_rule" "client_host_based_routing" {
  listener_arn = aws_lb_listener.aws_northwell_alb_listener.arn
  priority     = 4

  condition {
    host_header {
      values = ["northwell.stickball.biz"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.northwell_client_targetgroup.arn
  }
}