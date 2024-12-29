variable "CLOUD_REGION" {
    description = "AWS Region"
    default = "us-west-2"
}

variable "AIRPORT_CODE" {
  type = map(string)
}

