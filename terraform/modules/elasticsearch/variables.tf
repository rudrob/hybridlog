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

variable master_user_arn {
  type = string
}

variable amazon_es_cognito_role_arn {
  type = string
}

variable ip_whitelist {
  type = list(string)
}

variable user_pool_id {
  type = string
}

variable identity_pool_id {
  type = string
}
