variable "ec2_log_group_name" {
  description = "The name of the CloudWatch log group for EC2 logs"
  type        = string
}

variable "log_retention_in_days" {
  description = "Number of days to retain logs in CloudWatch"
  type        = number
  default     = 30
}
