provider "aws" {
    region = var.region
    profile = var.profile
}

module "website_s3_bucket" {
    source = "../../modules/aws/s3/static-website"

    application_name = var.application_name

    tags = {
        "Name" = "${var.application_name}-${terraform.workspace}"
        "Application" = var.application_name
        "Environment" = upper(terraform.workspace)
        "Terraform" = "true"
    }
}

terraform {
    backend "s3" {
        bucket = "abobrinha-application-terraform-remote-state"
        encrypt = true
        key = "terraform.tfstate"

        dynamodb_table = "abobrinha-application-terraform-state-lock"
        region = "us-east-1"
        profile = "Terraform"
    }
}