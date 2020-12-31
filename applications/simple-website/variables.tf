variable "application_name" {
    description = "Name of the application. Must be unique in AWS."
    type = string
}

# variable "tags" {
#     description = "Tags to set on the bucket."
#     type = map(string)
#     default = {}
# }

variable "region" {
    default = {
        dev = "us-east-1"
        hml = "us-east-1"
        prd = "us-west-2"
    }
}

variable "profile" {
    default = "Terraform"
}