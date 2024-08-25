variable "tags" {
  type = map(string)
}

variable "aws_lambda_function_arn" {
  description = "The ARN of the Lambda function to be triggered"
  type        = string
}

variable "sns_name" {
  type = string
}
