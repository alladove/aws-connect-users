# Connect Users Module

This module is responsible for deploying users which depend on security profiles and routing profiles.

## Resources

- `awscc_connect_user`

## Prerequisites

None

## Dependencies

The following module(s) must be deployed first:

* [aws-connect-instance](https://github.com/alladove/aws-connect-instance)
* [aws-connect-resources](https://github.com/alladove/aws-connect-resources) - users will use security and routing profiles