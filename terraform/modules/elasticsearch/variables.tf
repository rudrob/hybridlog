variable instance_type {
  type = string
}

variable instance_count{
  type = number
}

variable elasticsearch_version {
  type = string
}

variable domain_name {
  type = string
}

variable volume_size {
  type = number
}

variable subnet_ids {
  type = list(string)
}

variable cluster_subnet_count {
  type = number
}

variable create_service_linked_role {
  type = bool
}

variable vpc_id {
  type = string
}

variable sg_ingress_cidrs {
  type = list(string)
}

variable sg_egress_cidrs {
  type = list(string)
}
