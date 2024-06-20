output "users" {
  value = var.enable_contact_instance ? {
    for idx, user in awscc_connect_user.this :
    idx => {
      arn = user.user_arn
    }
  } : null
  description = "All users with key and arn."
}

output "connect_user_secret_arns" {
  value = var.identity_management_type == "CONNECT_MANAGED" ? { for k, v in aws_secretsmanager_secret.for_connect_managed_user : k => v.arn } : {}
}