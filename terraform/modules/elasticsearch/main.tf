resource "aws_iam_user" "es_publisher" {
  name = "es-publisher"
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.es_publisher.name
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

  cognito_options {
    enabled          = true
    user_pool_id     = var.user_pool_id
    identity_pool_id = var.identity_pool_id
    # ARN of the IAM role that has the AmazonESCognitoAccess policy attached
    role_arn         = var.amazon_es_cognito_role_arn
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = false
    master_user_options {
      master_user_arn = var.master_user_arn
    }
  }

  tags = {
    Domain = var.domain_name
  }


  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "es:ESHttp*"
        ]
        Effect    = "Allow"
        Resource  = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
        Principal = { AWS = [aws_iam_user.es_publisher.arn] }
        Condition = { IpAddress = { "aws:SourceIp" = var.ip_whitelist } }
      },
      {
        Action = [
          "es:ESHttp*"
        ]
        Effect    = "Allow"
        Resource  = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
        Principal = { AWS = [var.master_user_arn] }
      }
    ]
  })
}
