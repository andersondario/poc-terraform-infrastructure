provider "aws" {
    region = var.region
    profile = var.profile
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = "${var.application_name}-terraform-remote-state"
    acl = "private"

    versioning {
        enabled = true
    }

    force_destroy = terraform.workspace == "prd"? false : true

    tags = var.tags
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
    name = "${var.application_name}-terraform-state-lock"
    hash_key = "LockID"
    read_capacity = 10
    write_capacity = 10

    attribute {
        name = "LockID"
        type = "S"
    }

    tags = var.tags
}