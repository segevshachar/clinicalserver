data "aws_caller_identity" "current" {}

locals {
  desire_count     = var.environment == "prod" ? "2" : "1"

  account_id = data.aws_caller_identity.current.account_id
}
