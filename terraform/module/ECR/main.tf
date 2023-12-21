resource "aws_ecr_repository" "repo" {
  name                 = "${var.prefix}-${var.env}-${var.environments}"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "${var.prefix}-${var.env}-${var.environments}"
  }
}