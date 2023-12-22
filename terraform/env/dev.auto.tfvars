prefix     = "Stickball"
env        = "Northwell"
#####VPC
vpc = {
  vpc_cidr_block = "10.0.0.0/16"
  subnet_count = 2
  aws_region = "us-east-1"
  route_cidr_block = "0.0.0.0/0"
}

######SG
sg = {
  ingress1_protocol    = "tcp"
  ingress1_cidr_blocks = "0.0.0.0/0"
  ingress2_protocol    = "tcp"
  ingress2_cidr_blocks = "0.0.0.0/0"
  egress1_protocol     = "-1"
  egress1_cidr_blocks  = "0.0.0.0/0"
  ingress_port         = 80
  egress_port          = 0

  ###sb-admin
  ingress_port2        = 3000
  ###sb-server
  ingress_port3       = 3001
}

# ######ECS
ecs = {
  family        = "nginx-service"
  image         = "nginx:latest"
  cpu           = 2048
  memory        = 4096
  essential     = true
  containerport = 80
  hostport      = 80
  desired_count = 1
}
#######ALB
alb = {
  port                = 80
  admin_port          = 3000
  server_port         = 3001
  enabled             = true
  interval            = 300
  path                = "/"
  timeout             = 60
  matcher             = 200
  healthy_threshold   = 5
  unhealthy_threshold = 5
}

#######Environments
environments = {
  admin      = "sb-admin"
  server     = "sb-server"
  client     = "sb-client"
  calculator = "sb-budget-calculator"
  store      = "sb-online-store"
  zillow     = "sb-zillow"
  table      = "sb-data-filter-table"
  money      = "sb-super-money"
  experion   = "sb-experion"
  env        = "northwell"
}





