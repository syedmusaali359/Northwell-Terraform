resource "aws_ecs_cluster" "ecs_northwell_cluster" {
  name = "${var.prefix}-${var.env}-Cluster"
}
resource "aws_ecs_task_definition" "service" {
  family                   = var.ecs.family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  execution_role_arn       = "arn:aws:iam::003718499156:role/Northwell_ECS_TASK"
  container_definitions = jsonencode([
    {
      name      = "${var.prefix}-${var.env}-Container"
      image     = var.ecs.image
      essential = var.ecs.essential
      "portMappings" : [
        {
          containerPort = var.ecs.containerport
          hostPort      = var.ecs.hostport
        }
      ]
    },
  ])
}
resource "aws_ecs_service" "northwell_service" {
  launch_type = "FARGATE"

  name            = "${var.prefix}-${var.env}-Nginx-Service"
  cluster         = aws_ecs_cluster.ecs_northwell_cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.ecs.desired_count

  network_configuration {
    assign_public_ip = "false"
    subnets          = var.private_subnet_id[*]
    security_groups  = [var.sg_id]
  }
  load_balancer {
    target_group_arn = var.aws_alb_target_group
    container_name   = "${var.prefix}-${var.env}-Container"
    container_port   = var.ecs.containerport
  }
}

