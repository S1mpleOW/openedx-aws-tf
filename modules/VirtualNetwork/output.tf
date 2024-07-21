output "vpc_main_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_range" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_id_1" {
  value = aws_subnet.public_1.id
}

output "public_subnet_id_2" {
  value = aws_subnet.public_2.id
}

output "public_subnet_id_3" {
  value = aws_subnet.public_3.id
}
