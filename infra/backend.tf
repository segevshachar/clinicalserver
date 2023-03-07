terraform {
  backend "s3" {
    bucket = "terraform-state-clinical"
    key    = "terraform-state"
    region = "us-east-2"
  }
}
