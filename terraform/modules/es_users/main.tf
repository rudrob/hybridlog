terraform {
  required_providers {
    elasticsearch = {
      source  = "phillbaker/elasticsearch"
      version = "~> 1.5.3"
    }
  }
}

resource "elasticsearch_opendistro_role" "reader" {
  role_name   = "app_reader"
  description = "App Reader Role"

  index_permissions {
    index_patterns  = ["suricata*", "modsecurity*"]
    allowed_actions = ["get", "read", "search"]
  }
}

resource "elasticsearch_opendistro_user" "reader" {
  username = "es-reader"
  password = var.reader_password
}

resource "elasticsearch_opendistro_user" "writer" {
  username = "es-writer"
  password = var.writer_password
}

resource "elasticsearch_opendistro_role" "writer" {
  role_name   = "es-writer"
  description = "Writer Role"

  index_permissions {
    index_patterns  = ["suricata*", "modsecurity*"]
    allowed_actions = ["write"]
  }
}

resource "elasticsearch_opendistro_roles_mapping" "reader" {
  role_name   = elasticsearch_opendistro_role.reader.id
  description = "Reader Role"
  users       = [elasticsearch_opendistro_user.reader.id]
}

resource "elasticsearch_opendistro_roles_mapping" "writer" {
  role_name   = elasticsearch_opendistro_role.writer.id
  description = "Writer Role"
  users       = [elasticsearch_opendistro_user.writer.id]
}