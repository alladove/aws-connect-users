locals {
  users = var.enable_contact_instance ? var.users : {}
}

resource "random_password" "for_connect_managed_user" {
  for_each         = var.identity_management_type == "CONNECT_MANAGED" ? var.users : {}
  length           = 16
  special          = true
  override_special = "!@#"
}

resource "random_id" "secret_suffix" {
  for_each    = var.identity_management_type == "CONNECT_MANAGED" ? var.users : {}
  byte_length = 2
}

resource "aws_secretsmanager_secret" "for_connect_managed_user" {
  for_each = var.identity_management_type == "CONNECT_MANAGED" ? var.users : {}
  name     = "aws-connect-user-${each.key}-${random_id.secret_suffix[each.key].hex}"

  lifecycle {
    ignore_changes = [
      name
    ]
  }
}

resource "aws_secretsmanager_secret_version" "for_connect_managed_user" {
  for_each = var.identity_management_type == "CONNECT_MANAGED" ? var.users : {}

  secret_id = aws_secretsmanager_secret.for_connect_managed_user[each.key].id

  secret_string = jsonencode({
    username = each.key
    password = random_password.for_connect_managed_user[each.key].result
  })
}

resource "awscc_connect_user" "this" {
  for_each = local.users

  instance_arn          = var.connect_instance_arn
  username              = each.key
  security_profile_arns = each.value.security_profile_arns
  routing_profile_arn   = each.value.routing_profile_arn
  phone_config = {
    phone_type                    = each.value.phone_config.phone_type
    auto_accept                   = each.value.phone_config.auto_accept
    after_contact_work_time_limit = each.value.phone_config.after_contact_work_time_limit
    desk_phone_number             = each.value.phone_config.desk_phone_number
  }

  directory_user_id   = each.value.directory_user_id
  hierarchy_group_arn = each.value.hierarchy_group_arn
  password            = var.identity_management_type == "CONNECT_MANAGED" ? random_password.for_connect_managed_user[each.key].result : null

  identity_info = each.value.identity_info != null ? {
    first_name      = each.value.identity_info.first_name
    last_name       = each.value.identity_info.last_name
    email           = each.value.identity_info.email
    secondary_email = each.value.identity_info.secondary_email
    mobile          = each.value.identity_info.mobile
  } : null

  user_proficiencies = each.value.user_proficiencies != null ? [for proficiency in each.value.user_proficiencies : {
    attribute_name  = proficiency.name
    attribute_value = proficiency.value
    level           = proficiency.level
  }] : null

  tags = each.value.tags != null ? [for tag in each.value.tags : {
    key   = tag.key
    value = tag.value
  }] : []
}
