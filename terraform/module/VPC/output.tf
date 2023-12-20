output "ALL_AZ" {
    value = data.aws_availability_zones.available.names 
}
output "vpc_id" {
  value = aws_vpc.northwell-vpc.id
}
output "public_subnet_id" {
  value = aws_subnet.northwell-public-subnet[*].id
}
output "private_subnet_id" {
  value = aws_subnet.northwell-private-subnet[*].id
}