output "aws_alb" {
  value = aws_lb.aws_northwell_alb.arn
}
output "aws_alb_target_group" {
  value = aws_lb_target_group.northwell_targetgroup.arn
}

