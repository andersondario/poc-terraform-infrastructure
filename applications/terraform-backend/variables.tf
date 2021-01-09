variable "api_base_path" {
    description = "Base path of the endpoints. Example of url: <URL>/<BASE_PATH>/<VERSION>/resource"
    type = string
}

variable "api_version" {
    description = "Version of the API. Example of url: <URL>/<BASE_PATH>/<VERSION>/resource"
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

variable "region" {
    type = string
}

variable "profile" {
    default = "Terraform"
}

variable "application_name" {
    description = "Name of the application. Must be unique in AWS."
    type = string
}