output "ec2_log_group_arn" {
  description = "The ARN of the EC2 CloudWatch log group"
  value       = aws_cloudwatch_log_group.ec2_log_group.arn
}

output "ec2_log_group_name" {
  description = "The name of the EC2 CloudWatch log group"
  value       = aws_cloudwatch_log_group.ec2_log_group.name
}
