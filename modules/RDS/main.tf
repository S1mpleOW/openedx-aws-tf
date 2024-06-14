resource "aws_db_subnet_group" "edx_rds_subnet" {
  subnet_ids  = var.subnet_ids
  name        = "edx-rds-subnet-group"
  description = "DB subnet group for Open edX"
}

resource "aws_db_instance" "edx_rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  identifier           = "edx-rds-instance"
  username             = "admin"
  password             = var.mysql_password
  db_subnet_group_name = aws_db_subnet_group.edx_rds_subnet.name
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.rds_sg_id]

  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  tags = merge(var.tags, {
    created-date = "2024-05-29"
    Name = "edx-rds-instance"
  })
}
