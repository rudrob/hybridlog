# elasticsearch free tier is
# 750 hours per month of a single-AZ t2.small.elasticsearch or t3.small.elasticsearch instance
# 10GB per month of optional EBS storage (Magnetic or General Purpose)

instance_type              = "t2.small.elasticsearch"
volume_size                = 10
elasticsearch_version      = "7.9"
domain_name                = "seclog"
cluster_subnet_count       = 1
instance_count             = 1
create_service_linked_role = false
