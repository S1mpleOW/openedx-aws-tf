output "vpc_main_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_range" {
  value = aws_vpc.main.cidr_block
}

output "database-subnet-id-1" {
  value = aws_subnet.database-main-1.id
}

output "database-subnet-id-2" {
  value = aws_subnet.database-main-2.id
}

output "application-main-subnet-id" {
  value = aws_subnet.application-main.id
}
