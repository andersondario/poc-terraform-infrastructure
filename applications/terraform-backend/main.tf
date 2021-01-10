provider "aws" {
    region = var.region
    profile = var.profile
}

module "lambda" {
    source = "../../modules/aws/lambda/rest"

    lambdas_definitions = var.lambdas_definitions
    application_name = var.application_name
    region = var.region
    account_id = var.account_id

    tags = {
        "Name" = "${var.application_name}-${terraform.workspace}"
        "Application" = var.application_name
        "Environment" = upper(terraform.workspace)
        "Terraform" = "true"
    }
}

terraform {
    backend "s3" {
        bucket = "anderson-arendt-terraform-backend-terraform-remote-state"
        encrypt = true
        key = "terraform.tfstate"

        dynamodb_table = "anderson-arendt-terraform-backend-terraform-state-lock"
        region = "us-east-1"
        profile = "Terraform"
    }
}