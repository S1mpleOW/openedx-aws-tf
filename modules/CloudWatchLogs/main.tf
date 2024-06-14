resource "aws_cloudwatch_log_group" "ec2_log_group" {
  name              = var.ec2_log_group_name
  retention_in_days = var.log_retention_in_days
}
