variable "region" {
    description = "AWS Region"
    type = string

    default = "us-east-1"
}

variable "profile" {
    description = "Terraform profile name"
    type = string

    default = "Terraform"
}

variable "application_name" {
    description = "Name of the application. Must be unique in AWS."
    type = string
}

variable "tags" {
    description = "Tags to set on the bucket."
    type = map(string)
    default = {}
}
