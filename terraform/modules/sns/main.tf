resource "aws_sns_topic" "es_alerts" {
  name              = "${var.topic_prefix_name}-alerts"
}

resource "aws_iam_role" "es_sns_role" {
  name        = "es_sns_role"
  description = "this role is used by es service to publish communicates to sns topic"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "es.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "allow_alert_sns_publish" {
  name        = "allow-alert-sns-publish"
  description = "this policy allows to publish communicates to sns topic user for elasticsearch alerts"
  policy = jsonencode({
    Version : "2012-10-17"
    Statement : [{
      Effect : "Allow"
      Action : "sns:Publish"
      Resource : aws_sns_topic.es_alerts.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "es_sns_attachment" {
  role       = aws_iam_role.es_sns_role.name
  policy_arn = aws_iam_policy.allow_alert_sns_publish.arn
}