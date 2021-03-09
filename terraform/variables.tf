### ELASTICSEARCH
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

variable create_service_linked_role {
  type = bool
}

variable master_user_name {
  type = string
}

variable master_user_password {
  type = string
}

