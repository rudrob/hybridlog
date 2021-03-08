resource "aws_cognito_user_pool" "hybridlog" {
  name = "hybridlog"

  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }

  username_configuration {
    case_sensitive = false
  }
}

resource "aws_cognito_identity_pool" "hybridlog" {
  identity_pool_name               = "hybridlog"
  allow_unauthenticated_identities = false

//  cognito_identity_providers {
//    client_id               = var.client_id
//    provider_name           = var.provider_name
//    server_side_token_check = true
//  }
}

# Todo
//resource "aws_cognito_identity_pool_roles_attachment" "main" {
//  identity_pool_id = aws_cognito_identity_pool.main.id
//
//  role_mapping {
//    identity_provider         = "graph.facebook.com"
//    ambiguous_role_resolution = "AuthenticatedRole"
//    type                      = "Rules"
//
//    mapping_rule {
//      claim      = "isAdmin"
//      match_type = "Equals"
//      role_arn   = aws_iam_role.authenticated.arn
//      value      = "paid"
//    }
//  }
//
//  roles = {
//    "authenticated" = aws_iam_role.authenticated.arn
//  }
//}