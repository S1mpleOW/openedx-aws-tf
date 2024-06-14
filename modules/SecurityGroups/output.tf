output "edx_sg_id" {
  value = aws_security_group.edx_sg.id
}

output "mongodb_sg_id" {
  value = aws_security_group.mongodb_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "elasticsearch_sg_id" {
  value = aws_security_group.elasticsearch_sg.id
}

output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}
