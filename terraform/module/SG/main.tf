resource "aws_security_group" "northwell-allow-tls" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.sg.ingress_port
    to_port     = var.sg.ingress_port
    protocol    = var.sg.ingress2_protocol
    cidr_blocks = [var.sg.ingress2_cidr_blocks]
  }
  ingress {
    from_port   = var.sg.ingress_port2
    to_port     = var.sg.ingress_port2
    protocol    = var.sg.ingress2_protocol
    cidr_blocks = [var.sg.ingress2_cidr_blocks]
  }
  ingress {
    from_port   = var.sg.ingress_port3
    to_port     = var.sg.ingress_port3
    protocol    = var.sg.ingress2_protocol
    cidr_blocks = [var.sg.ingress2_cidr_blocks]
  }

  egress {
    from_port   = var.sg.egress_port
    to_port     = var.sg.egress_port
    protocol    = var.sg.egress1_protocol
    cidr_blocks = [var.sg.egress1_cidr_blocks]
  }

  tags = {
    Name = "${var.prefix}-${var.env}-Security-Group"
  }
}