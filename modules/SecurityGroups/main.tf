# Security Group for Open edX Tutor
resource "aws_security_group" "edx_sg" {
  name   = "edx_sg"
  vpc_id = var.vpc_id

  tags = merge(var.default_tags, {
    created-date = "2024-05-27"
    service      = "NSG"
  })
}

resource "aws_security_group_rule" "edx_sg_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.edx_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "edx_sg_allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.edx_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "edx_sg_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.edx_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "edx_sg_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.edx_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security Group for MongoDB
resource "aws_security_group" "mongodb_sg" {
  vpc_id = var.vpc_id
  name = "edx-mongodb-sg"
  tags = merge(var.default_tags, {
    created-date = "2024-05-27"
    service      = "NSG"
  })
}

resource "aws_security_group_rule" "mongodb_sg_allow_mongo" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  security_group_id = aws_security_group.mongodb_sg.id
  cidr_blocks       = [var.vpc_cidr_range]
}

resource "aws_security_group_rule" "mongodb_sg_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.mongodb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "mongodb_sg_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.mongodb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id
  name = "rds-sg"

  tags = merge(var.default_tags, {
    created-date = "2024-05-27"
    service      = "NSG"
  })
}

resource "aws_security_group_rule" "rds_sg_allow_mysql" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  cidr_blocks       = [var.vpc_cidr_range]
}

resource "aws_security_group_rule" "rds_sg_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.rds_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security Group for Elasticsearch
resource "aws_security_group" "elasticsearch_sg" {
  vpc_id = var.vpc_id
  name = "elasticsearch-sg"

  tags = merge(var.default_tags, {
    created-date = "2024-05-27"
    service      = "NSG"
  })
}

resource "aws_security_group_rule" "elasticsearch_sg_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.elasticsearch_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elasticsearch_sg_allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.elasticsearch_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elasticsearch_sg_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.elasticsearch_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "redis_sg" {
  vpc_id = var.vpc_id
  name = "redis-sg"

  tags = merge(var.default_tags, {
    created-date = "2024-05-27"
    service      = "NSG"
  })
}

resource "aws_security_group_rule" "redis_sg_allow_redis_6379" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = aws_security_group.redis_sg.id
  cidr_blocks       = [var.vpc_cidr_range]
}

resource "aws_security_group_rule" "redis_sg_allow_redis_6380" {
  type              = "ingress"
  from_port         = 6380
  to_port           = 6380
  protocol          = "tcp"
  security_group_id = aws_security_group.redis_sg.id
  cidr_blocks       = [var.vpc_cidr_range]
}

resource "aws_security_group_rule" "redis_sg_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.redis_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
