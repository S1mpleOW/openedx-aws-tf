resource "aws_sns_topic" "openedx_topic" {
  name = var.sns_name
  tags = merge(var.tags, {
    Name = var.sns_name
  })
}

resource "aws_sns_topic_subscription" "topic_lambda_subscription" {
  topic_arn = aws_sns_topic.openedx_topic.arn
  protocol  = "lambda"
  endpoint = var.aws_lambda_function_arn
}
