locals {
  instance_alias           = "connect-managed-example"
  identity_management_type = "CONNECT_MANAGED"

  tags = {
    project = "important-project"
  }

  # awscc modules prefer lists to maps
  tags_list = [for key, value in local.tags : { key = key, value = value }]
}

module "users" {
  source = "./.."

  enable_contact_instance  = true
  connect_instance_arn     = var.connect_instance_arn
  identity_management_type = local.identity_management_type
  users                    = local.users

  tags = local.tags_list
}