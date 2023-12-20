output "ecs_service" {
  value = aws_ecs_service.northwell_service.id
}