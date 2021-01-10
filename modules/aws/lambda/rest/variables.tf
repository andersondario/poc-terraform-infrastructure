variable "application_name" {
    description = "Name of the application. Must be unique in AWS."
    type = string
}

variable "tags" {
    description = "Tags to set on the bucket."
    type = map(string)
    default = {}
}

variable "account_id" {
    description = "AWS Account ID"
    type = string
}

variable "region" {
    description = "AWS Region"
    type = string
}

variable "lambdas_definitions" {
    description = "The definition os the lambdas"

    type = map(object({
        lambda_code_bucket = string
        lambda_zip_path = string
        handle_path = string
        runtime = string
        method = string
        path = string
    }))
}

