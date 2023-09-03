terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}



resource "aws_dynamodb_table" "table001" {
  name           = "Table001"
  billing_mode   = "PAY_PER_REQUEST"
  stream_enabled = false
  hash_key       = "partition_key"
  range_key      = "sort_key"

  deletion_protection_enabled = false

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "partition_key"
    type = "S"
  }

  attribute {
    name = "sort_key"
    type = "N"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  aws_region     = data.aws_region.current.name
  aws_account_id = data.aws_caller_identity.current.account_id
}

resource "aws_kms_alias" "main" {
  name          = "alias/javaencrypt-ddb"
  target_key_id = aws_kms_key.main.id
}

resource "aws_kms_key" "main" {
  description             = "kms-javaencrypt-ddb-key"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          "AWS" : "arn:aws:iam::${local.aws_account_id}:root"
        }
        Action   = "kms:*",
        Resource = "*"
      }
    ]
  })
}
