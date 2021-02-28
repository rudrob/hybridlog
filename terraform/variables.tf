
### NETWORKING
variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "subnet_cidrs" {
  type = list(string)
}

variable "elasticsearch_tag" {
  type = string
}

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

variable cluster_subnet_count {
  type = number
}

variable create_service_linked_role {
  type = bool
}
