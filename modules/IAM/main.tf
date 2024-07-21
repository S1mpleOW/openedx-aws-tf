resource "aws_iam_role" "cloudwatch_agent_role" {
  name = "CloudWatchAgentRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_agent_policy" {
  name = "CloudWatchAgentPolicy"
  role = aws_iam_role.cloudwatch_agent_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "${var.ec2_log_group_arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_user" "openedx_s3_user" {
  name = "openedx-s3-user-${var.stage_name}"
  tags = var.default_tags
}

resource "aws_iam_access_key" "openedx_s3_user_access_key" {
  user = aws_iam_user.openedx_s3_user.name
}

data "aws_iam_policy_document" "openedx_s3_user_policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*", "s3-object-lambda:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "openedx_s3_user_policy" {
  name        = "openedx-s3-user-policy-${var.stage_name}"
  description = "Policy for openedx-s3-user"
  policy      = data.aws_iam_policy_document.openedx_s3_user_policy_document.json
}
