output "documentdb_endpoint" {
  value = aws_docdb_cluster.openedx_cluster.endpoint
}

output "documentdb_port" {
  value = aws_docdb_cluster.openedx_cluster.port
}

output "documentdb_master_username" {
  value = aws_docdb_cluster.openedx_cluster.master_username
}

output "documentdb_master_password" {
  value = aws_docdb_cluster.openedx_cluster.master_password
}
