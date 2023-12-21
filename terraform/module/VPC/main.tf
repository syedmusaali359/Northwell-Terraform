data "aws_availability_zones" "available" {
    state = "available"
}
resource "aws_vpc" "northwell-vpc" {
  cidr_block = var.vpc.vpc_cidr_block 

  tags = {
    Name = "${var.prefix}-${var.env}-Vpc"
  }
}
/**START OF PUBLIC*/
resource "aws_subnet" "northwell-public-subnet" {
  count = var.vpc.subnet_count
  vpc_id     = aws_vpc.northwell-vpc.id
  cidr_block = cidrsubnet(var.vpc.vpc_cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.prefix}-${var.env}-Public-Subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "northwell-public-route-table" {
  vpc_id = aws_vpc.northwell-vpc.id

  route   {
    cidr_block = var.vpc.route_cidr_block
    gateway_id = aws_internet_gateway.northwell-igw.id
  }

  tags = {
    Name = "${var.prefix}-${var.env}-Public-Route-Table"
  }
}
resource "aws_route_table_association" "northwell-public-subnet-route-table-association" {
  count = var.vpc.subnet_count
  subnet_id      = aws_subnet.northwell-public-subnet[count.index].id
  route_table_id = aws_route_table.northwell-public-route-table.id
}
resource "aws_internet_gateway" "northwell-igw" {
  vpc_id = aws_vpc.northwell-vpc.id

  tags = {
    Name = "${var.prefix}-${var.env}-Internet-Gateway"
  }
}

/**END OF PUBLIC*/



/**START OF PRIVATE*/
resource "aws_subnet" "northwell-private-subnet" {
  count = var.vpc.subnet_count
  vpc_id     = aws_vpc.northwell-vpc.id
  cidr_block        = cidrsubnet(var.vpc.vpc_cidr_block, 8, count.index + 10)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.prefix}-${var.env}-Private-Subnet-${count.index + 1}"
  }

  map_public_ip_on_launch = false
}
resource "aws_route_table" "northwell-private-route-table" { 
  vpc_id = aws_vpc.northwell-vpc.id

  route {
    cidr_block        = var.vpc.route_cidr_block 
    nat_gateway_id = aws_nat_gateway.northwell-nat-gw.id
  }

  tags = {
    Name = "${var.prefix}-${var.env}-Private-Route-Table"
  }
}

resource "aws_route_table_association" "northwell-private-subnet-route-table-association" {
    count = var.vpc.subnet_count
    subnet_id = aws_subnet.northwell-private-subnet[count.index].id
    route_table_id = aws_route_table.northwell-private-route-table.id
}

 
resource "aws_eip" "northwell-nat-eip" {
  tags = {
    Name = "${var.prefix}-${var.env}-NAT-Eip"
  }
}

resource "aws_nat_gateway" "northwell-nat-gw" {
  allocation_id = aws_eip.northwell-nat-eip.id
  subnet_id     = aws_subnet.northwell-public-subnet[0].id

  tags = {
    Name = "${var.prefix}-${var.env}-NAT-Gateway"
  }
  depends_on = [aws_internet_gateway.northwell-igw]
}
/**END OF PRIVATE*/

