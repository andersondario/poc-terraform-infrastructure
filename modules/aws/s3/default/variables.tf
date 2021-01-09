variable "application_name" {
    description = "Name of the application. Must be unique in AWS."
    type = string
}

variable "tags" {
    description = "Tags to set on the bucket."
    type = map(string)
    default = {}
}
