variable "enable_contact_instance" {
  description = "Enable the creation of the AWS Connect instance."
  type        = bool
  default     = true
}

variable "connect_instance_arn" {
  description = "The ARN of the AWS Connect instance."
  type        = string
}

variable "identity_management_type" {
  description = "The type of identity management for the instance. Possible values: `SAML`, `CONNECT_MANAGED`, `EXISTING_DIRECTORY`."
  type        = string
}

variable "users" {
  description = "A map of users, where each key is the username."
  type = map(object({
    security_profile_arns : list(string)
    routing_profile_arn : string
    phone_config : object({
      phone_type : string # E.g., 'SOFT_PHONE', 'DESK_PHONE'
      auto_accept : optional(bool)
      after_contact_work_time_limit : optional(number)
      desk_phone_number : optional(string)
    })
    directory_user_id : optional(string) # Optional, for linking to an existing directory user
    hierarchy_group_arn : optional(string)
    identity_info : optional(object({
      first_name : optional(string)
      last_name : optional(string)
      email : optional(string)
      secondary_email : optional(string)
      mobile : optional(string)
    }))
    user_proficiencies : optional(list(object({
      name  = string
      value = string
      level = number
    })))
    tags : optional(list(object({
      key   = string
      value = string
    })))
  }))
  default = {}
}

# Other
variable "tags" {
  description = "A list of tags, where each tag is an object with a key and a value."
  type = list(object({
    key   = string
    value = string
  }))
  default = []
}
