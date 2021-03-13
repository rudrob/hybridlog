module "elasticsearch" {
  source                     = "../modules/elasticsearch"
  instance_type              = var.instance_type
  volume_size                = var.volume_size
  elasticsearch_version      = var.elasticsearch_version
  domain_name                = var.domain_name
  instance_count             = var.instance_count
  create_service_linked_role = var.create_service_linked_role
  master_user_name           = var.master_user_name
  master_user_password       = var.master_user_password
  cw_logging_types           = var.cw_logging_types
  ip_whitelist               = var.ip_whitelist
}

module "sns" {
  source            = "../modules/sns"
  topic_prefix_name = var.domain_name
}
