output "amazon_es_cognito_role_arn" {
  value = aws_iam_role.amazon_es_cognito_role.arn
}

output "user_pool_id" {
  value = aws_cognito_user_pool.hybridlog.id
}

output "identity_pool_id" {
  value = aws_cognito_identity_pool.hybridlog.id
}

output "master_user_arn" {
  value = aws_iam_role.cognito_hybridlog_auth_role.arn
}