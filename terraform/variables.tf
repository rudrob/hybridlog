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

variable master_user_name {
  type = string
}

variable master_user_password {
  type = string
}

variable ip_whitelist {
  type = list(string)
}

variable "client_id" {
  type = string
}

variable "provider_name" {
  type = string
}

