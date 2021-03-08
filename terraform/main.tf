module "elasticsearch" {
  depends_on                 = [module.cognito]
  source                     = "./modules/elasticsearch"
  instance_type              = var.instance_type
  volume_size                = var.volume_size
  elasticsearch_version      = var.elasticsearch_version
  domain_name                = var.domain_name
  instance_count             = var.instance_count
  amazon_es_cognito_role_arn = module.cognito.amazon_es_cognito_role_arn
  master_user_arn            = module.cognito.master_user_arn
  ip_whitelist               = var.ip_whitelist
  user_pool_id               = module.cognito.user_pool_id
  identity_pool_id           = module.cognito.identity_pool_id
}

module "cognito" {
  source        = "./modules/cognito"
  provider_name = var.provider_name
  client_id     = var.client_id
}
