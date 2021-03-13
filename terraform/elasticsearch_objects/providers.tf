terraform {
  required_version = "~> 0.14.7"

  required_providers {
    elasticsearch = {
      source  = "phillbaker/elasticsearch"
      version = "~> 1.5.3"
    }
  }
}

provider "elasticsearch" {
  url                   = "https://${data.terraform_remote_state.main.outputs.elasticsearch_url}"
  sniff                 = false
  healthcheck           = false
  elasticsearch_version = var.elasticsearch_version
  username              = var.master_user_name
  password              = var.master_user_password
  sign_aws_requests     = false
}