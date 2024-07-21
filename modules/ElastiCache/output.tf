output "endpoint_redis_edx" {
  value = aws_elasticache_cluster.edx_redis.cache_nodes[0].address
}
