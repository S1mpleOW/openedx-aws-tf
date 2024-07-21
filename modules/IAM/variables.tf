variable "ec2_log_group_arn" {
  description = "The ARN of the CloudWatch log group for EC2 logs"
  type        = string
}

variable "stage_name" {
  type = string
}

variable "default_tags" {
  type = map(string)
}
