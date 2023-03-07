data "aws_elb_service_account" "main" {}

data "aws_caller_identity" "current" {}

resource "aws_lb" "lb" {
  access_logs {
    bucket  = "clinical-${var.environment}-lb"
    enabled = "true"
    prefix  = "access-log"
  }

  drop_invalid_header_fields = "false"
  enable_deletion_protection = "false"
  enable_http2               = "true"
  idle_timeout               = "120"
  internal                   = "false"
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  name                       = "${var.environment}-lb"
  security_groups            = [var.sg_id]

  subnets = var.subnets

  tags = {
    Name        = "${var.environment}-lb",
    Environment = var.environment,
    Automation  = "Terraform"
  }
}

resource "aws_s3_bucket" "lb_server_access_log_bucket" {
  bucket        = "clinical-${var.environment}-lb"
  force_destroy = "true"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_elb_service_account.main.id}:root"
      },
      "Resource": "arn:aws:s3:::clinical-${var.environment}-lb/access-log/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "Sid": "AWSConsoleStmt-1632737210495"
    },
    {
      "Action": "s3:PutObject",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Resource": "arn:aws:s3:::clinical-${var.environment}-lb/access-log/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "Sid": "AWSLogDeliveryWrite"
    },
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Resource": "arn:aws:s3:::clinical-${var.environment}-lb",
      "Sid": "AWSLogDeliveryAclCheck"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


