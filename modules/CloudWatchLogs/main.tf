resource "aws_cloudwatch_log_group" "ec2_log_group" {
  name              = var.ec2_log_group_name
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_metric_alarm" "increase_ec2_alarm" {
  alarm_name                = "Notification_CPU_Utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 50
  alarm_description         = "This metric monitors ec2 cpu utilization, if it goes above 70% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []
  alarm_actions = [
    "${var.sns_topic_arn}"
  ]

  dimensions = {
    InstanceId = "${var.ec2_instance_id}"
  }
}
