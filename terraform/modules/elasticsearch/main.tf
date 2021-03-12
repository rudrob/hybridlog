resource "aws_iam_user" "es_publisher" {
  name = "es-publisher"
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.es_publisher.name
}

resource "aws_iam_service_linked_role" "es" {
  count            = var.create_service_linked_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "main" {
  domain_name           = var.domain_name
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = var.volume_size
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  tags = {
    Domain = var.domain_name
  }

  depends_on = [aws_iam_service_linked_role.es]

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "es:ESHttp*"
        ]
        Effect    = "Allow"
        Resource  = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
        Principal = { AWS = "*" }
        Condition = { IpAddress = { "aws:SourceIp" = var.ip_whitelist } }
      }
    ]
  })
  dynamic "log_publishing_options" {
    for_each = toset(var.cw_logging_types)
    content {
      cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_cloudwatch_log_group[log_publishing_options.value].arn
      log_type                 = log_publishing_options.value
    }
  }

}

resource "aws_cloudwatch_log_group" "es_cloudwatch_log_group" {
  for_each = toset(var.cw_logging_types)
  name     = "es_cloudwatch_group_${each.value}"
}

resource "aws_cloudwatch_log_resource_policy" "es_cloudwatch_policy" {
  policy_name = "es_cloudwatch_policy"

  policy_document = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          Effect : "Allow"
          Principal : {
            "Service" : "es.amazonaws.com"
          },
          Action : [
            "logs:PutLogEvents",
            "logs:PutLogEventsBatch",
            "logs:CreateLogStream"
          ],
          Resource : "arn:aws:logs:*"
        }
      ]
  })
}
