output "endpoint_mysql_edx" {
  value = aws_db_instance.edx_rds.address
}

output "username_mysql_edx" {
  value = aws_db_instance.edx_rds.username
}

output "password_mysql_edx" {
  value = aws_db_instance.edx_rds.password
}
