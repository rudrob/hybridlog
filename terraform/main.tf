module "elasticsearch" {
  source                      = "./modules/elasticsearch"
  instance_type               = var.instance_type
  volume_size                 = var.volume_size
  elasticsearch_version       = var.elasticsearch_version
  domain_name                 = var.domain_name
  instance_count              = var.instance_count
  create_service_linked_role  = var.create_service_linked_role
  kibana_master_user_name     = var.kibana_master_user_name
  kibana_master_user_password = var.kibana_master_user_password
}
