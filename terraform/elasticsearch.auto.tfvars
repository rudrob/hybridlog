# elasticsearch free tier is
# 750 hours per month of a single-AZ t2.small.elasticsearch or t3.small.elasticsearch instance
# but disclaimer - The T2 instance types do not support encryption of data at rest, fine-grained access control,
# UltraWarm storage, cross-cluster search, or Auto-Tune.
# 10GB per month of optional EBS storage (Magnetic or General Purpose)

instance_type              = "t3.small.elasticsearch"
volume_size                = 10
elasticsearch_version      = "7.9"
domain_name                = "hybridlog2"
cluster_subnet_count       = 1
instance_count             = 1
create_service_linked_role = false

