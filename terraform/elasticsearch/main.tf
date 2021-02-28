resource "aws_iam_user" "es_publisher" {
  name = "es-publisher"
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.es_publisher.name
}

resource "aws_security_group" "main" {
  name        = "elasticsearch-${var.domain_name}"
  description = "Security group for elasticsearch cluster nodes"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      data.terraform_remote_state.networking.outputs.vpc_cidr
    ]
  }
}

resource "aws_iam_service_linked_role" "es" {
  count = var.create_service_linked_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "main" {
  domain_name           = var.domain_name
  elasticsearch_version = var.elasticsearch_version


  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = var.volume_size
  }

  vpc_options {
    subnet_ids         = slice(data.terraform_remote_state.networking.outputs.subnet_ids, 0, var.subnet_count)
    security_group_ids = [aws_security_group.main.id]
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
          "es:*"
        ]
        Effect    = "Allow"
        Resource  = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
        Principal = { AWS = [data.aws_caller_identity.current.arn, aws_iam_user.es_publisher.arn] }
      },
    ]
  })
}
