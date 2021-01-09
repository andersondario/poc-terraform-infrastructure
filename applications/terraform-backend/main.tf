provider "aws" {
    region = var.region
    profile = var.profile
}

module "lambda" {
    source = "../../modules/aws/lambda/rest"

    lambdas_definitions = var.lambdas_definitions
    application_name = var.application_name
    api_base_path = var.api_base_path
    api_version = var.api_version

    tags = {
        "Name" = "${var.application_name}-${terraform.workspace}"
        "Application" = var.application_name
        "Environment" = upper(terraform.workspace)
        "Terraform" = "true"
    }
}

terraform {
    backend "s3" {
        bucket = "anderson-arendt-backend-terraform-remote-state"
        encrypt = true
        key = "terraform.tfstate"

        dynamodb_table = "anderson-arendt-backend-terraform-state-lock"
        region = "us-east-1"
        profile = "Terraform"
    }
}