variable "master_user_name" {
  type = string
}

variable "master_user_password" {
  type = string
}

variable "elasticsearch_version" {
  type = string
}

variable "reader_password" {
  type    = string
  default = ""
}

variable "writer_password" {
  type    = string
  default = ""
}

variable "create_users" {
  type    = bool
  default = false
}

variable "shards_num" {
  type    = number
  default = 1
}

variable "replicas_num" {
  type    = number
  default = 1
}