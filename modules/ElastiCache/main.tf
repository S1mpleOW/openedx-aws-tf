resource "aws_elasticache_parameter_group" "edx_redis_parameter_group" {
  family      = "redis7"
  name        = "edx-redis-parameter-group"
  description = "OpenedX ElastiCache Parameter Group"
}

resource "aws_elasticache_subnet_group" "edx_redis_subnet_group" {
  name        = "edx-redis-subnet-group"
  description = "ElastiCache Subnet Group"
  subnet_ids = [
    var.subnet_id,
  ]
}

resource "aws_elasticache_cluster" "edx_redis" {
  cluster_id           = "edx-redis"
  engine_version       = "7.0"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.edx_redis_parameter_group.name
  subnet_group_name    = aws_elasticache_subnet_group.edx_redis_subnet_group.name
  engine               = "redis"
  port                 = 6379
  security_group_ids   = [var.redis_sg_id]
}
