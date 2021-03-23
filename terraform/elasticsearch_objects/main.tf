locals {
  sns_arn              = data.terraform_remote_state.main.outputs.sns_arn
  es_alerting_role_arn = data.terraform_remote_state.main.outputs.es_alerting_role_arn
}

# Should rollover be configured? Maybe? But seems not supported easily by provider
resource "elasticsearch_index" "suricata-log" {
  name               = "suricata-log"
  number_of_shards   = var.shards_num
  number_of_replicas = var.replicas_num
  # (Boolean) A boolean that indicates that the index should be deleted even if it contains documents.
  # ??? is it even working
  force_destroy = true
}

resource "elasticsearch_index" "modsecurity-log" {
  name               = "modsecurity-log"
  number_of_shards   = var.shards_num
  number_of_replicas = var.replicas_num
  # (Boolean) A boolean that indicates that the index should be deleted even if it contains documents.
  # ??? is it even working
  force_destroy = true
}

// for some reason there is a bug in this resource when it's created each time even when it's already there in
// kibana and tf state - perhaps it's a api bug or sth

resource "elasticsearch_opendistro_destination" "sns_alerts_destination" {
  body = jsonencode(
    {
      name : "sns_destination",
      type : "sns",
      sns : {
        topic_arn : local.sns_arn,
        role_arn : local.es_alerting_role_arn
      }
  })
}

resource "elasticsearch_opendistro_monitor" "suricata_monitor" {
  body = jsonencode(
    {
      enabled = true
      inputs = [
        {
          search = {
            indices = [
              elasticsearch_index.suricata-log.name,
            ]
            query = {
              query = {
                bool = {
                  adjust_pure_negative = true
                  boost                = 1
                  must = [
                    {
                      range = {
                        "@timestamp" = {
                          boost         = 1
                          from          = "{{period_end}}||-5m"
                          include_lower = false
                          include_upper = true
                          to            = "{{period_end}}"
                        }
                      }
                    },
                    {
                      term = {
                        event_type = {
                          boost = 1
                          value = "alert"
                        }
                      }
                    },
                  ]
                }
              }
            }
          }
        },
      ]
      name = "suricata_alerts"
      schedule = {
        period = {
          interval = 5
          unit     = "MINUTES"
        }
      }
      triggers = [
        {
          actions = [
            {
              destination_id = elasticsearch_opendistro_destination.sns_alerts_destination.id
              id             = "sPQ4JngB6ZdXNTBrgUmD"
              message_template = {
                lang   = "mustache"
                source = file("./resources/suricata_alert_message.txt")
              }
              name = "send_to_sns"
              subject_template = {
                lang   = "mustache"
                source = "Suricata alert"
              }
              throttle = {
                unit  = "MINUTES"
                value = 5
              }
              throttle_enabled = true
            },
          ]
          condition = {
            script = {
              lang   = "painless"
              source = "ctx.results[0].hits.total.value > 0"
            }
          }
          id       = "r_Q4JngB6ZdXNTBrgUmD"
          name     = "sns"
          severity = "1"
        },
      ]
      type = "monitor"
      user = {
        backend_roles          = []
        custom_attribute_names = []
        name                   = var.master_user_name
        roles = [
          "all_access",
          "security_manager",
        ]
        user_requested_tenant = null
      }
    }
  )
}

resource "elasticsearch_opendistro_monitor" "modsecurity_monitor" {
  body = jsonencode(
    {
      enabled = true
      inputs = [
        {
          search = {
            indices = [
              elasticsearch_index.modsecurity-log.name,
            ]
            query = {
              query = {
                bool = {
                  adjust_pure_negative = true
                  boost                = 1
                  must = [
                    {
                      range = {
                        "@timestamp" = {
                          boost         = 1
                          from          = "{{period_end}}||-5m"
                          include_lower = false
                          include_upper = true
                          to            = "{{period_end}}"
                        }
                      }
                    },
                    {
                      exists : {
                        "field" : "audit_data.messages"
                      }
                    },
                  ]
                }
              }
            }
          }
        },
      ]
      name = "modsecurity_alerts"
      schedule = {
        period = {
          interval = 5
          unit     = "MINUTES"
        }
      }
      triggers = [
        {
          actions = [
            {
              destination_id = elasticsearch_opendistro_destination.sns_alerts_destination.id
              id             = "sPQ4JngB6ZdXNTBrgUmD"
              message_template = {
                lang   = "mustache"
                source = file("./resources/modsecurity_alert_message.txt")
              }
              name = "send_to_sns"
              subject_template = {
                lang   = "mustache"
                source = "Modsecurity alert"
              }
              throttle = {
                unit  = "MINUTES"
                value = 5
              }
              throttle_enabled = true
            },
          ]
          condition = {
            script = {
              lang   = "painless"
              source = "ctx.results[0].hits.total.value > 0"
            }
          }
          id       = "r_Q4JngB6ZdXNTBrgUmD"
          name     = "sns"
          severity = "1"
        },
      ]
      type = "monitor"
      user = {
        backend_roles          = []
        custom_attribute_names = []
        name                   = var.master_user_name
        roles = [
          "all_access",
          "security_manager",
        ]
        user_requested_tenant = null
      }
    }
  )
}

module "es_users" {
  count           = var.create_users ? 1 : 0
  source          = "../modules/es_users"
  reader_password = var.reader_password
  writer_password = var.writer_password
}
