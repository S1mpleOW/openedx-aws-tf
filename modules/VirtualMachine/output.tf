output "mongodb_host" {
  value = aws_instance.mongodb_instance.private_dns
}

output "edx_public_ip" {
  value = aws_instance.openedx_instance.public_ip
}
