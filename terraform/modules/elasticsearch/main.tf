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
      master_user_name     = var.kibana_master_user_name
      master_user_password = var.kibana_master_user_password
    }
  }

  tags = {
    Domain = var.domain_name
  }

  depends_on = [aws_iam_service_linked_role.es]

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
//      {
//        Action = [
//          "es:ESHttp*"
//        ]
//        Effect    = "Allow"
//        Resource  = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
//        Principal = { AWS = [aws_iam_user.es_publisher.arn] }
//        Condition = { IpAddress = { "aws:SourceIp" = ["85.221.142.99/32"] } }
//        },
      {
        Action = [
          "es:ESHttp*"
        ]
        Effect    = "Allow"
        Resource  = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
        Principal = { AWS = "*" }
        Condition = { IpAddress = { "aws:SourceIp" = ["85.221.142.99/32"] } }
      }
    ]
  })
}
