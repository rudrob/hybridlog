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