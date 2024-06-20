locals {
  # You can either pass a map for a few users, or for a large user base create a json document with all the data, store it in S3 and parse it with terraform to populate this
  users = {
    "jane.joe" = {
      security_profile_arns : ["this-is-required_get-it-from-aws-connect-resources-module"]
      routing_profile_arn : "this-is-required_get-it-from-aws-connect-resources-module",
      phone_config : {
        phone_type : "SOFT_PHONE"
      }
      identity_info : {
        first_name : "Jane"
        last_name : "Joe"
        email : "jane.doe@example.com"
      }
    },
  }
}