output "elasticsearch_url" {
  value = aws_elasticsearch_domain.main.endpoint
}

output "kibana_url" {
  value = aws_elasticsearch_domain.main.kibana_endpoint
}
