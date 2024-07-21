output "aws_cloudwatch_agent_profile_role_name" {
  value = aws_iam_role.cloudwatch_agent_role.name
}

output "iam_s3_arn" {
  value = aws_iam_user.openedx_s3_user.arn
}

output "aws_s3_access_key" {
  value = aws_iam_access_key.openedx_s3_user_access_key.id
}

output "aws_s3_secret_key" {
  value = aws_iam_access_key.openedx_s3_user_access_key.secret
}
