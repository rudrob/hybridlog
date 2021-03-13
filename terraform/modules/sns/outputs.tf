output "sns_arn" {
  value = aws_sns_topic.es_alerts.arn
}

output "es_alerting_role_arn" {
  value = aws_iam_role.es_sns_role.arn
}
