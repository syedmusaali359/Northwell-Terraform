resource "aws_ecr_repository" "repo" {
  name                 = "${var.env}-${var.environments}"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "${var.env}-${var.environments}"
  }
}