
locals {
  desire_count     = var.environment == "prod" ? "2" : "1"
  sanity_test_desire_count = var.environment == "dev" ? "1" : "0"
}
