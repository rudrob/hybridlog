module "networking" {
  source             = "./modules/networking"
  availability_zones = var.availability_zones
  subnet_cidrs       = var.subnet_cidrs
  vpc_cidr           = var.vpc_cidr
  elasticsearch_tag  = var.elasticsearch_tag
}

module "elasticsearch" {
  depends_on                 = [module.networking]
  source                     = "./modules/elasticsearch"
  instance_type              = var.instance_type
  volume_size                = var.volume_size
  elasticsearch_version      = var.elasticsearch_version
  domain_name                = var.domain_name
  instance_count             = var.instance_count
  create_service_linked_role = var.create_service_linked_role
  vpc_id                     = module.networking.vpc_id
  cluster_subnet_count       = var.cluster_subnet_count
  subnet_ids                 = module.networking.subnet_ids
  sg_ingress_cidrs           = [var.vpc_cidr]
}
