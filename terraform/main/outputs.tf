output "elasticsearch_url" {
  value = "https://${module.elasticsearch.elasticsearch_url}"
}

output "kibana_url" {
  value = "https://${module.elasticsearch.kibana_url}"
}

output "es_alerting_role_arn" {
  value = module.sns.es_alerting_role_arn
}

output "sns_arn" {
  value = module.sns.sns_arn
}


